// lib/screens/cheque_deposit_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cheque_provider.dart';
import '../models/cheque_deposit.dart';

class ChequeDepositDetails extends ConsumerWidget {
  final ChequeDeposit deposit;

  ChequeDepositDetails({required this.deposit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cheques = ref.watch(chequeProvider);
    final depositCheques = cheques
        .where((cheque) => deposit.chequeNos.contains(cheque.chequeNo))
        .toList();
    final totalAmount = deposit.calculateTotalAmount(depositCheques);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cheque Deposit Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Deposit Type: ${deposit.status}',
              style: TextStyle(color: Colors.blueGrey[700]),
            ),
            Text(
              'Deposit Date: ${DateFormat('dd/MM/yyyy').format(deposit.depositDate)}',
              style: TextStyle(color: Colors.blueGrey[700]),
            ),
            Text(
              'Status: ${deposit.status}',
              style: TextStyle(color: Colors.blueGrey[700]),
            ),
            Text(
              'Number of Cheques: ${deposit.chequeNos.length}',
              style: TextStyle(color: Colors.blueGrey[700]),
            ),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: depositCheques.length,
                itemBuilder: (ctx, index) {
                  final cheque = depositCheques[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        child:
                            const Icon(Icons.image, color: Colors.blueAccent),
                      ),
                      title: Text(
                        'Cheque No: ${cheque.chequeNo}',
                        style: TextStyle(color: Colors.blueGrey[800]),
                      ),
                      subtitle: Text(
                        'Amount: \$${cheque.amount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility,
                            color: Colors.blueAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(16.0),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Cheque No: ${cheque.chequeNo}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'assets/YalaPay-data/cheques/${cheque.chequeImageUri}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Text(
                                          'Cheque image not available.',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close',
                                        style: TextStyle(
                                            color: Colors.blueAccent)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
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
