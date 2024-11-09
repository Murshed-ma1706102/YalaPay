import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/providers/payments_provider.dart';
import '../models/payment.dart';
import '../providers/mode_payment_provider.dart';

class UpdatePaymentScreen extends ConsumerWidget {
  final List<String> paymentModes = ["cheque", "bank transfer", "credit card"];
  String selectedPaymentMode = "cheque";

  final String invoiceId;
  final String paymentId;

  UpdatePaymentScreen(
      {super.key, required this.invoiceId, required this.paymentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMode = ref.watch(paymentModeProvider);
    final payment = ref.watch(paymentProvider.notifier).getPaymentById(paymentId);
    final TextEditingController amountController = TextEditingController(text: payment.amount.toString());
    final TextEditingController paymentDateController = TextEditingController();
    final TextEditingController chequeNoController = TextEditingController(text: payment.chequeNo?.toString() ?? '');

    void updatePayment() {
      final newPayment = Payment(
        id: paymentId, // Use the same id
        invoiceNo: invoiceId, // use the same invoice id
        amount: double.tryParse(amountController.text) ?? 0.0,
        paymentDate: paymentDateController.text,
        paymentMode: selectedPaymentMode,
        chequeNo: selectedPaymentMode == "cheque"
            ? int.tryParse(chequeNoController.text)
            : null,
      );

      // Add the payment to the state using Riverpod
      ref.read(paymentProvider.notifier).updatePayment(paymentId,newPayment);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('payment updated successfully!'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              // Code to execute when the action is pressed.
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Payment Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: paymentDateController,
              decoration: const InputDecoration(
                labelText: "Payment Date",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
              ),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  paymentDateController.text =
                      selectedDate.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedPaymentMode,
              decoration: const InputDecoration(
                labelText: "Payment Mode",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
              ),
              items: paymentModes.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
              onChanged: (value) {
                if(value != null){
                  ref.watch(paymentModeProvider.notifier).state = value;
                }
              },
            ),
            const SizedBox(height: 16.0),
            if (selectedPaymentMode == "cheque") // Optional cheque number field
              TextFormField(
                controller: chequeNoController,
                decoration: const InputDecoration(
                  labelText: "Cheque No",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: updatePayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Update Payment",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
