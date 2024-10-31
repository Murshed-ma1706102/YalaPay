import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../providers/cheque_provider.dart';
import '../providers/cheque_deposit_provider.dart';
import '../models/cheque.dart';
import '../models/cheque_deposit.dart';

class ChequesScreen extends ConsumerStatefulWidget {
  const ChequesScreen({super.key});

  @override
  _ChequesScreenState createState() => _ChequesScreenState();
}

class _ChequesScreenState extends ConsumerState<ChequesScreen> {
  final List<Cheque> _selectedCheques = [];
  String? _selectedBankAccount;
  List<String> _bankAccounts = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBankAccounts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        const SnackBar(
            content: Text('Please select cheques and a bank account.')),
      );
      return;
    }

    final depositDate = DateTime.now();
    final deposit = ChequeDeposit(
      id: depositDate.toString(),
      depositDate: depositDate,
      bankAccountNo: _selectedBankAccount!,
      status: 'Deposited',
      chequeNos: _selectedCheques.map((cheque) => cheque.chequeNo).toList(),
    );

    ref.read(chequeDepositProvider.notifier).addDeposit(deposit);

    final chequeNotifier = ref.read(chequeProvider.notifier);
    for (var cheque in _selectedCheques) {
      cheque.status = 'Deposited';
      cheque.dueDate = depositDate;
      chequeNotifier.updateCheque(cheque.chequeNo, cheque);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cheques deposited successfully.')),
    );

    setState(() {
      _selectedCheques.clear();
      _selectedBankAccount = null;
    });
  }

  Widget _buildBankAccountDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Bank Account',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedBankAccount,
            isExpanded: true,
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
          ),
        ),
      ),
    );
  }

  Widget _buildChequeTable(List<Cheque> awaitingCheques) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
        columnSpacing: 16.0,
        columns: const <DataColumn>[
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Bank')),
          DataColumn(label: Text('Number')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
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
                  style:
                      TextStyle(color: isOverdue ? Colors.red : Colors.green),
                ),
              ),
              DataCell(Text('\$${cheque.amount.toStringAsFixed(2)}')),
              DataCell(
                Text(
                  cheque.status,
                  style: const TextStyle(color: Colors.orange),
                ),
              ),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {
                      // Navigate to EditChequeScreen with cheque details
                      context.go('/cheques/edit', extra: cheque);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      // Confirm before deleting
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Cheque'),
                          content: const Text(
                              'Are you sure you want to delete this cheque?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      // If confirmed, delete the cheque
                      if (shouldDelete == true) {
                        ref
                            .read(chequeProvider.notifier)
                            .deleteCheque(cheque.chequeNo);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Cheque deleted successfully.')),
                        );
                      }
                    },
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final awaitingCheques = ref
        .watch(chequeProvider)
        .where((cheque) => cheque.status == 'Awaiting')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Cheque Deposit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () {
              context.go('/cheques/deposits');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          _buildBankAccountDropdown(),
          const SizedBox(height: 16.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: _buildChequeTable(awaitingCheques),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: _confirmDeposit,
              child: const Text(
                'Confirm Deposit',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
