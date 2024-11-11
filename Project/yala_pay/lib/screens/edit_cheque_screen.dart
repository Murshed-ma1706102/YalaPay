// lib/screens/edit_cheque_screen.dart

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
      final updatedCheque = Cheque(
        chequeNo: _chequeNo,
        drawer: _drawer,
        bankName: _bankName,
        dueDate: _dueDate,
        amount: _amount,
        status: widget.cheque.status,
        receivedDate: widget.cheque.receivedDate,
        chequeImageUri: widget.cheque.chequeImageUri,
      );

      ref.read(chequeProvider.notifier).updateCheque(_chequeNo, updatedCheque);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cheque updated successfully.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Cheque'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _drawer,
                decoration: InputDecoration(
                  labelText: 'Drawer',
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the drawer name' : null,
                onChanged: (value) => _drawer = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _bankName,
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the bank name' : null,
                onChanged: (value) => _bankName = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _chequeNo.toString(),
                decoration: InputDecoration(
                  labelText: 'Cheque Number',
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter cheque number' : null,
                onChanged: (value) => _chequeNo = int.parse(value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount.toStringAsFixed(2),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.blueGrey[700]),
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the amount' : null,
                onChanged: (value) => _amount = double.parse(value),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Due Date: ${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                  style: TextStyle(color: Colors.blueGrey[800]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today,
                      color: Colors.blueAccent),
                  onPressed: () => _selectDueDate(context),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCheque,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
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
