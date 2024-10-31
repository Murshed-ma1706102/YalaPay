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
      appBar: AppBar(title: const Text('Add New Deposit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Select Bank Account'),
                items: [
                  'Account 1',
                  'Account 2'
                ] // Replace with actual accounts
                    .map((account) =>
                        DropdownMenuItem(value: account, child: Text(account)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBankAccount = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a bank account' : null,
              ),
              ListTile(
                title: Text(
                    'Deposit Date: ${DateFormat('dd/MM/yyyy').format(_depositDate)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDepositDate(context),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select Cheques for Deposit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: allCheques
                    .map((cheque) => CheckboxListTile(
                          title: Text(
                              'Cheque No: ${cheque.chequeNo} - \$${cheque.amount}'),
                          value: _selectedChequeNos.contains(cheque.chequeNo),
                          onChanged: (_) =>
                              _toggleChequeSelection(cheque.chequeNo),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDeposit,
                child: const Text('Add Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
