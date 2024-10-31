import 'package:flutter/material.dart';
import '../models/cheque_deposit.dart';

class EditChequeDepositScreen extends StatefulWidget {
  final ChequeDeposit deposit;

  EditChequeDepositScreen({required this.deposit});

  @override
  _EditChequeDepositScreenState createState() => _EditChequeDepositScreenState();
}

class _EditChequeDepositScreenState extends State<EditChequeDepositScreen> {
  late String _status;
  final _statusOptions = ['Pending', 'Cashed', 'Returned'];

  @override
  void initState() {
    super.initState();

    // Ensure that _status is within _statusOptions, or set a default value.
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
      appBar: AppBar(title: Text('Edit Cheque Deposit')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _status,
              onChanged: (newValue) => setState(() => _status = newValue!),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
