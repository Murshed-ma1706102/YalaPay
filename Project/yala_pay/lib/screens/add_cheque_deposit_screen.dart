// lib/screens/add_cheque_deposit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cheque_deposit_provider.dart';
import '../providers/cheque_provider.dart';
import '../models/cheque_deposit.dart';

class AddChequeDepositScreen extends ConsumerStatefulWidget {
  @override
  _AddChequeDepositScreenState createState() => _AddChequeDepositScreenState();
}

class _AddChequeDepositScreenState
    extends ConsumerState<AddChequeDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBankAccount;
  DateTime _depositDate = DateTime.now();
  final List<int> _selectedChequeNos = [];

  void _selectDepositDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _depositDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _depositDate = selectedDate;
      });
    }
  }

  void _toggleChequeSelection(int chequeNo) {
    setState(() {
      if (_selectedChequeNos.contains(chequeNo)) {
        _selectedChequeNos.remove(chequeNo);
      } else {
        _selectedChequeNos.add(chequeNo);
      }
    });
  }

  void _addDeposit() {
    if (_formKey.currentState!.validate() && _selectedChequeNos.isNotEmpty) {
      final newDeposit = ChequeDeposit(
        id: DateTime.now().toString(),
        depositDate: _depositDate,
        bankAccountNo: _selectedBankAccount!,
        status: 'Pending',
        chequeNos: _selectedChequeNos,
      );

      // Add the deposit to the provider
      ref.read(chequeDepositProvider.notifier).addDeposit(newDeposit);

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cheque deposit added successfully.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCheques = ref.watch(chequeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New Deposit'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Bank Account',
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Account 1', 'Account 2']
                    .map((account) => DropdownMenuItem(
                          value: account,
                          child: Text(account),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBankAccount = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a bank account' : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Deposit Date: ${DateFormat('dd/MM/yyyy').format(_depositDate)}',
                  style: TextStyle(color: Colors.blueGrey[800]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today,
                      color: Colors.blueAccent),
                  onPressed: () => _selectDepositDate(context),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Cheques for Deposit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: allCheques
                    .map((cheque) => CheckboxListTile(
                          title: Text(
                            'Cheque No: ${cheque.chequeNo} - \$${cheque.amount}',
                            style: TextStyle(color: Colors.blueGrey[900]),
                          ),
                          value: _selectedChequeNos.contains(cheque.chequeNo),
                          onChanged: (_) =>
                              _toggleChequeSelection(cheque.chequeNo),
                          activeColor: Colors.blueAccent,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addDeposit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Deposit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
