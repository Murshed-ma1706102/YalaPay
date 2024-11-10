// lib/screens/edit_cheque_deposit_screen.dart

import 'package:flutter/material.dart';
import '../models/cheque_deposit.dart';

class EditChequeDepositScreen extends StatefulWidget {
  final ChequeDeposit deposit;

  EditChequeDepositScreen({required this.deposit});

  @override
  _EditChequeDepositScreenState createState() =>
      _EditChequeDepositScreenState();
}

class _EditChequeDepositScreenState extends State<EditChequeDepositScreen> {
  late String _status;
  final _statusOptions = ['Pending', 'Cashed', 'Returned'];

  @override
  void initState() {
    super.initState();

    _status = _statusOptions.contains(widget.deposit.status)
        ? widget.deposit.status
        : _statusOptions[0];
  }

  void _saveChanges() {
    setState(() {
      widget.deposit.status = _status;
    });
    Navigator.of(context).pop(widget.deposit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cheque Deposit'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _status,
              onChanged: (newValue) => setState(() => _status = newValue!),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Status',
                labelStyle: TextStyle(color: Colors.blueGrey[700]),
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
