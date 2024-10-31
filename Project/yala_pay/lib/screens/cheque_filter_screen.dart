import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = selectedDate;
        } else {
          _toDate = selectedDate;
        }
      });
    }
  }

  void _filterCheques() {
    final allCheques = ref.read(chequeProvider);

    setState(() {
      _filteredCheques = allCheques.where((cheque) {
        final isWithinDateRange =
            (_fromDate == null || cheque.dueDate.isAfter(_fromDate!)) &&
                (_toDate == null || cheque.dueDate.isBefore(_toDate!));

        final matchesStatus =
            _selectedStatus == 'All' || cheque.status == _selectedStatus;
        return isWithinDateRange && matchesStatus;
      }).toList();

      if (_selectedStatus == 'All') {
        _calculateTotalsByStatus(allCheques);
      } else {
        _totalAmount =
            _filteredCheques.fold(0.0, (sum, cheque) => sum + cheque.amount);
        _totalCount = _filteredCheques.length;
      }
    });
  }

  void _calculateTotalsByStatus(List<Cheque> allCheques) {
    final Map<String, double> amountByStatus = {
      'Awaiting': 0.0,
      'Deposited': 0.0,
      'Cashed': 0.0,
      'Returned': 0.0,
    };

    final Map<String, int> countByStatus = {
      'Awaiting': 0,
      'Deposited': 0,
      'Cashed': 0,
      'Returned': 0,
    };

    for (var cheque in allCheques) {
      if (amountByStatus.containsKey(cheque.status)) {
        amountByStatus[cheque.status] =
            amountByStatus[cheque.status]! + cheque.amount;
        countByStatus[cheque.status] = countByStatus[cheque.status]! + 1;
      }
    }

    setState(() {
      _totalAmount = amountByStatus.values.reduce((a, b) => a + b);
      _totalCount = countByStatus.values.reduce((a, b) => a + b);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Cheques')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                    'From Date: ${_fromDate != null ? DateFormat('dd/MM/yyyy').format(_fromDate!) : 'Not selected'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              ListTile(
                title: Text(
                    'To Date: ${_toDate != null ? DateFormat('dd/MM/yyyy').format(_toDate!) : 'Not selected'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Cheque Status'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _filterCheques,
                child: const Text('Filter Cheques'),
              ),
              const SizedBox(height: 20),
              if (_filteredCheques.isNotEmpty || _selectedStatus == 'All') ...[
                Text('Total Cheques: $_totalCount'),
                Text('Total Amount: \$${_totalAmount.toStringAsFixed(2)}'),
                const Divider(),
                if (_selectedStatus == 'All')
                  ..._statuses
                      .where((status) => status != 'All')
                      .map((status) => ListTile(
                            title: Text('Status: $status'),
                            subtitle: Text(
                                'Amount: \$${_filteredCheques.where((c) => c.status == status).fold(0.0, (sum, cheque) => sum + cheque.amount).toStringAsFixed(2)} | Count: ${_filteredCheques.where((c) => c.status == status).length}'),
                          )),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredCheques.length,
                  itemBuilder: (context, index) {
                    final cheque = _filteredCheques[index];
                    return ListTile(
                      title: Text('Cheque No: ${cheque.chequeNo}'),
                      subtitle: Text(
                          'Amount: \$${cheque.amount.toStringAsFixed(2)} | Status: ${cheque.status}'),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
