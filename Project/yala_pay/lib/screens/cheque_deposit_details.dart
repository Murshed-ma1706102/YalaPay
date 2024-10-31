// ChequeDepositDetails.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import '../providers/cheque_provider.dart';

class ChequeDepositDetails extends StatelessWidget {
  final ChequeDeposit deposit;

  ChequeDepositDetails({required this.deposit});

  @override
  Widget build(BuildContext context) {
    final chequeProvider = context.watch<ChequeProvider>();
    final depositCheques = chequeProvider.cheques
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
