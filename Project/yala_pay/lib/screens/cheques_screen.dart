import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cheque_provider.dart';
import '../providers/cheque_deposit_provider.dart';
import '../models/cheque.dart';
import '../models/cheque_deposit.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ChequesScreen extends StatefulWidget {
  @override
  _ChequesScreenState createState() => _ChequesScreenState();
}

class _ChequesScreenState extends State<ChequesScreen> {
  final List<Cheque> _selectedCheques = [];
  String? _selectedBankAccount;
  List<String> _bankAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadBankAccounts();
  }

  Future<void> _loadBankAccounts() async {
    try {
      final String data =
          await rootBundle.loadString('assets/YalaPay-data/bank-accounts.json');
      final List<dynamic> accounts = json.decode(data);

      setState(() {
        _bankAccounts = accounts.map((account) {
          if (account is Map<String, dynamic> &&
              account.containsKey('accountNo')) {
            return '${account['bank']} - ${account['accountNo']}';
          } else {
            return 'Unknown Account';
          }
        }).toList();
      });
    } catch (e) {
      print("Error loading bank accounts: $e");
      setState(() {
        _bankAccounts = [];
      });
    }
  }

  void _toggleChequeSelection(Cheque cheque) {
    setState(() {
      if (_selectedCheques.contains(cheque)) {
        _selectedCheques.remove(cheque);
      } else {
        _selectedCheques.add(cheque);
      }
    });
  }

  String _calculateRemainingDays(DateTime dueDate) {
    final difference = dueDate.difference(DateTime.now()).inDays;
    return difference >= 0 ? '($difference)' : '($difference)';
  }

  Future<void> _confirmDeposit() async {
    if (_selectedCheques.isEmpty || _selectedBankAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select cheques and a bank account.')),
      );
      return;
    }

    DateTime depositDate = DateTime.now();
    final deposit = ChequeDeposit(
      id: DateTime.now().toString(),
      depositDate: depositDate,
      bankAccountNo: _selectedBankAccount!,
      status: 'Deposited',
      chequeNos: _selectedCheques.map((cheque) => cheque.chequeNo).toList(),
    );

    final chequeDepositProvider = context.read<ChequeDepositProvider>();
    final chequeProvider = context.read<ChequeProvider>();

    chequeDepositProvider.addDeposit(deposit);

    for (var cheque in _selectedCheques) {
      cheque.status = 'Deposited';
      cheque.dueDate = depositDate;
      chequeProvider.updateCheque(cheque.chequeNo, cheque);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cheques deposited successfully.')),
    );

    setState(() {
      _selectedCheques.clear();
      _selectedBankAccount = null;
    });
  }

  Widget _buildBankAccountDropdown() {
    return DropdownButton<String>(
      hint: Text('Select Bank Account'),
      value: _selectedBankAccount,
      onChanged: (value) {
        setState(() {
          _selectedBankAccount = value;
        });
      },
      items: _bankAccounts.map((account) {
        return DropdownMenuItem(
          value: account,
          child: Text(account),
        );
      }).toList(),
    );
  }

  Widget _buildChequeTable(List<Cheque> awaitingCheques) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Bank')),
        DataColumn(label: Text('Number')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Statut')),
        DataColumn(label: Text('remaining')),
      ],
      rows: awaitingCheques.map((cheque) {
        final remainingDays = _calculateRemainingDays(cheque.dueDate);
        final isOverdue = cheque.dueDate.isBefore(DateTime.now());
        final formattedDate = DateFormat('dd/MM/yyyy').format(cheque.dueDate);

        return DataRow(
          selected: _selectedCheques.contains(cheque),
          onSelectChanged: (isSelected) => _toggleChequeSelection(cheque),
          cells: <DataCell>[
            DataCell(Text(cheque.drawer)),
            DataCell(Text(cheque.bankName)),
            DataCell(Text(cheque.chequeNo.toString())),
            DataCell(
              Text(
                '$formattedDate $remainingDays',
                style: TextStyle(color: isOverdue ? Colors.red : Colors.green),
              ),
            ),
            DataCell(Text('\$${cheque.amount.toStringAsFixed(2)}')),
            DataCell(
                Text(cheque.status, style: TextStyle(color: Colors.orange))),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.yellow),
                  onPressed: () {
                    // Implement edit functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Implement delete functionality here
                  },
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chequeProvider = context.watch<ChequeProvider>();
    final awaitingCheques = chequeProvider.cheques
        .where((cheque) => cheque.status == 'Awaiting')
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Create Cheque Deposit')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBankAccountDropdown(),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: _buildChequeTable(awaitingCheques))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _confirmDeposit,
              child: Text('Confirm Deposit'),
            ),
          ),
        ],
      ),
    );
  }
}
