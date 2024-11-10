// lib/screens/cheque_filter_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/cheque_provider.dart';
import '../models/cheque.dart';

class ChequeFilterScreen extends ConsumerStatefulWidget {
  @override
  _ChequeFilterScreenState createState() => _ChequeFilterScreenState();
}

class _ChequeFilterScreenState extends ConsumerState<ChequeFilterScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedStatus = 'All';
  List<Cheque> _filteredCheques = [];
  double _totalAmount = 0.0;
  int _totalCount = 0;

  final List<String> _statuses = [
    'All',
    'Awaiting',
    'Deposited',
    'Cashed',
    'Returned'
  ];

  void _selectDate(BuildContext context, bool isFromDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isFromDate ? DateTime(2000) : (_fromDate ?? DateTime(2000)),
      lastDate: isFromDate ? (_toDate ?? DateTime(2100)) : DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = selectedDate;
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = null;
          }
        } else {
          _toDate = selectedDate;
          if (_fromDate != null && _fromDate!.isAfter(_toDate!)) {
            _fromDate = null;
          }
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedStatus = 'All';
      _applyFilters();
    });
  }

  void _applyFilters() {
    final allCheques = ref.read(chequeProvider);

    setState(() {
      _filteredCheques = allCheques.where((cheque) {
        final isWithinDateRange = (_fromDate == null ||
                cheque.dueDate.isAtSameMomentAs(_fromDate!) ||
                cheque.dueDate.isAfter(_fromDate!)) &&
            (_toDate == null ||
                cheque.dueDate.isAtSameMomentAs(_toDate!) ||
                cheque.dueDate.isBefore(_toDate!));
        final matchesStatus =
            _selectedStatus == 'All' || cheque.status == _selectedStatus;
        return isWithinDateRange && matchesStatus;
      }).toList();

      _totalAmount =
          _filteredCheques.fold(0.0, (sum, cheque) => sum + cheque.amount);
      _totalCount = _filteredCheques.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Cheques'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  'From Date: ${_fromDate != null ? DateFormat('dd/MM/yyyy').format(_fromDate!) : 'Not selected'}',
                  style: TextStyle(color: Colors.blueGrey[800]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today,
                      color: Colors.blueAccent),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  'To Date: ${_toDate != null ? DateFormat('dd/MM/yyyy').format(_toDate!) : 'Not selected'}',
                  style: TextStyle(color: Colors.blueGrey[800]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today,
                      color: Colors.blueAccent),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Cheque Status',
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _resetFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Clear Filters',
                        style: TextStyle(color: Colors.black87)),
                  ),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Filter Cheques'),
                  ),
                  ElevatedButton(
                    onPressed: () => GoRouter.of(context).go('/reports'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Back'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_filteredCheques.isNotEmpty) ...[
                Text(
                  'Total Cheques: $_totalCount',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Total Amount: \$${_totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredCheques.length,
                  itemBuilder: (context, index) {
                    final cheque = _filteredCheques[index];
                    return ListTile(
                      title: Text('Cheque No: ${cheque.chequeNo}'),
                      subtitle: Text(
                        'Amount: \$${cheque.amount.toStringAsFixed(2)} | Status: ${cheque.status}',
                      ),
                    );
                  },
                ),
              ] else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No cheques found with the selected filters.',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
