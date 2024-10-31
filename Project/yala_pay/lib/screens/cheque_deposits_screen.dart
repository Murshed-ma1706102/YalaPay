import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yala_pay/providers/cheque_provider.dart';
import '../providers/cheque_deposit_provider.dart';
import '../models/cheque.dart';
import '../models/cheque_deposit.dart';

class ChequeDepositsScreen extends StatefulWidget {
  @override
  _ChequeDepositsScreenState createState() => _ChequeDepositsScreenState();
}

class _ChequeDepositsScreenState extends State<ChequeDepositsScreen> {
  void _viewDepositDetails(
      BuildContext context, ChequeDeposit deposit, List<Cheque> allCheques) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ChequeDepositDetails(
        deposit: deposit,
        cheques: allCheques,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chequeDepositProvider = context.watch<ChequeDepositProvider>();
    final deposits = chequeDepositProvider.deposits;
    final allCheques = context.watch<ChequeProvider>().cheques;

    return Scaffold(
      appBar: AppBar(title: const Text('Cheque Deposits')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: deposits.length,
        itemBuilder: (ctx, index) {
          final deposit = deposits[index];
          final totalAmount = deposit.calculateTotalAmount(allCheques);
          return Card(
            elevation: 3.0,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: ListTile(
              leading: const Icon(Icons.folder, color: Colors.blue),
              title: Text(
                'Deposit Type: ${deposit.status}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Deposit Date: ${DateFormat('dd/MM/yyyy').format(deposit.depositDate)}'),
                  Text('Status: ${deposit.status}'),
                  Text('Number of Cheques: ${deposit.chequeNos.length}'),
                  Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.green),
                    onPressed: () =>
                        _viewDepositDetails(context, deposit, allCheques),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      // Implement update functionality here
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      chequeDepositProvider.deleteDeposit(deposit.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement the functionality to create a new deposit
        },
        child: const Icon(Icons.add),
        tooltip: 'New Deposit',
      ),
    );
  }
}

class ChequeDepositDetails extends StatelessWidget {
  final ChequeDeposit deposit;
  final List<Cheque> cheques;

  ChequeDepositDetails({
    required this.deposit,
    required this.cheques,
  });

  @override
  Widget build(BuildContext context) {
    final depositCheques = cheques
        .where((cheque) => deposit.chequeNos.contains(cheque.chequeNo))
        .toList();
    final totalAmount = deposit.calculateTotalAmount(depositCheques);

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cheque Deposit Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text('Deposit Type: ${deposit.status}'),
            Text(
                'Deposit Date: ${DateFormat('dd/MM/yyyy').format(deposit.depositDate)}'),
            Text('Status: ${deposit.status}'),
            Text('Number of Cheques: ${deposit.chequeNos.length}'),
            Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: depositCheques.length,
                itemBuilder: (ctx, index) {
                  final cheque = depositCheques[index];
                  return ListTile(
                    leading: const Icon(Icons.image, color: Colors.blueAccent),
                    title: Text('Cheque No: ${cheque.chequeNo}'),
                    subtitle: Text(
                      'Amount: \$${cheque.amount.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        // Display cheque image or additional details here
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
