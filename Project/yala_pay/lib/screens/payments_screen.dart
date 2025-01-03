import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/providers/payments_provider.dart';
import 'package:yala_pay/routes/app_router.dart';
import '../models/payment.dart';

class PaymentsScreen extends ConsumerWidget {
  final String invoiceId;

  const PaymentsScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref
        .watch(paymentProvider)
        .where((payment) => payment.invoiceNo == invoiceId)
        .toList();

    return Scaffold(
     appBar: AppBar(
        title: const Text(
          "Payments",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed('addPayment',
                          pathParameters: {'invoiceId': invoiceId});
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Add Payment",
                      style: TextStyle(color: Colors.white),),
                  ),
                  
                    Text(
                      "Payments for Invoice #$invoiceId",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: payments.isEmpty
                    ? const Center(
                        child: Text("No payments available for this invoice."))
                    : ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          return PaymentCard(
                            payment: payment,
                            onDelete: () {

                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Payment deleted successfully!'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );

                              ref.read(paymentProvider.notifier).deletePayment(payment.id);
                             
                            },
                            onUpdate: () {
                              context.goNamed('updatePayment', pathParameters: {
                                'invoiceId': invoiceId,
                                'paymentId': payment.id
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment ID: ${payment.id}",
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text("Amount: ${payment.amount}"),
              Text("Date: ${payment.paymentDate}"),
              Text("Mode: ${payment.paymentMode}"),
              if (payment.paymentMode == "cheque" && payment.chequeNo != null)
                Text("Cheque No: ${payment.chequeNo}"),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onUpdate,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: const Text(
                      "Update Payment",
                      style: TextStyle(color: Colors.white),),
                  ),
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text(
                      "Delete Payment",
                      style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
