import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cheque_provider.dart';
import '../models/cheque.dart';

class EditChequeScreen extends ConsumerStatefulWidget {
  final Cheque cheque;

  EditChequeScreen({required this.cheque});

  @override
  _EditChequeScreenState createState() => _EditChequeScreenState();
}

class _EditChequeScreenState extends ConsumerState<EditChequeScreen> {
  final _formKey = GlobalKey<FormState>();

  late int _chequeNo;
  late String _drawer;
  late String _bankName;
  late DateTime _dueDate;
  late double _amount;

  @override
  void initState() {
    super.initState();
    _chequeNo = widget.cheque.chequeNo;
    _drawer = widget.cheque.drawer;
    _bankName = widget.cheque.bankName;
    _dueDate = widget.cheque.dueDate;
    _amount = widget.cheque.amount;
  }

  void _selectDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _saveCheque() {
    if (_formKey.currentState!.validate()) {
      // Update the cheque with the new values
      final updatedCheque = Cheque(
        chequeNo: _chequeNo,
        drawer: _drawer,
        bankName: _bankName,
        dueDate: _dueDate,
        amount: _amount,
        status: widget.cheque.status, // Preserve original status
        receivedDate:
            widget.cheque.receivedDate, // Use the original receivedDate
        chequeImageUri:
            widget.cheque.chequeImageUri, // Preserve original image URI
      );

      // Update the cheque in the provider
      ref.read(chequeProvider.notifier).updateCheque(_chequeNo, updatedCheque);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cheque updated successfully.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Cheque')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _drawer,
                decoration: const InputDecoration(labelText: 'Drawer'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the drawer name' : null,
                onChanged: (value) => _drawer = value,
              ),
              TextFormField(
                initialValue: _bankName,
                decoration: const InputDecoration(labelText: 'Bank Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the bank name' : null,
                onChanged: (value) => _bankName = value,
              ),
              TextFormField(
                initialValue: _chequeNo.toString(),
                decoration: const InputDecoration(labelText: 'Cheque Number'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter cheque number' : null,
                onChanged: (value) => _chequeNo = int.parse(value),
              ),
              TextFormField(
                initialValue: _amount.toStringAsFixed(2),
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the amount' : null,
                onChanged: (value) => _amount = double.parse(value),
              ),
              ListTile(
                title: Text(
                    'Due Date: ${DateFormat('dd/MM/yyyy').format(_dueDate)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDueDate(context),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCheque,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
