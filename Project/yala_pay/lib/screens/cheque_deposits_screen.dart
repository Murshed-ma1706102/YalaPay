// lib/screens/cheque_deposits_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/cheque_provider.dart';
import '../providers/cheque_deposit_provider.dart';

class ChequeDepositsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deposits = ref.watch(chequeDepositProvider);
    final allCheques = ref.watch(chequeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cheque Deposits'),
        backgroundColor: Colors.blueAccent,
      ),
      body: deposits.isEmpty
          ? const Center(
              child: Text(
                'No deposits available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: deposits.length,
              itemBuilder: (ctx, index) {
                final deposit = deposits[index];
                final totalAmount = deposit.calculateTotalAmount(allCheques);

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(Icons.folder, color: Colors.blueAccent),
                    ),
                    title: Text(
                      'Deposit Type: ${deposit.status}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deposit Date: ${DateFormat('dd/MM/yyyy').format(deposit.depositDate)}',
                          style: TextStyle(color: Colors.blueGrey[700]),
                        ),
                        Text('Status: ${deposit.status}'),
                        Text('Number of Cheques: ${deposit.chequeNos.length}'),
                        Text(
                          'Total: \$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.visibility, color: Colors.green),
                          onPressed: () {
                            context.go(
                              '/cheques/deposits/details',
                              extra: deposit,
                            );
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            context.go(
                              '/cheques/deposits/edit',
                              extra: deposit,
                            );
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () =>
                              _deleteDeposit(context, ref, deposit.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          context.go('/cheques/deposits/add');
        },
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'New Deposit',
      ),
    );
  }

  void _deleteDeposit(
      BuildContext context, WidgetRef ref, String depositId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deposit'),
        content: const Text('Are you sure you want to delete this deposit?'),
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

    if (confirm == true) {
      // Call delete on the provider without expecting a return value.
      ref.read(chequeDepositProvider.notifier).deleteDeposit(depositId);

      // Show success snackbar assuming deletion is successful.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cheque deposit deleted successfully.'),
        ),
      );
    }
  }
}
