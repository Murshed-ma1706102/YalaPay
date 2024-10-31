import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cheque_provider.dart';
import '../providers/cheque_deposit_provider.dart';

class ChequeDepositsScreen extends StatelessWidget {
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
                    onPressed: () {
                      final deposit =
                          deposits[index]; // Get the selected deposit
                      context.go(
                        '/cheques/deposits/details',
                        extra: deposit,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      context.go(
                        '/cheques/deposits/edit',
                        extra: deposit, // Pass deposit object to edit screen
                      );
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
