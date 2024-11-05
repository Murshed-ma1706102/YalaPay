import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/providers/payments_provider.dart';
import '../models/payment.dart';

class AddPaymentScreen extends ConsumerWidget {
  
  final TextEditingController amountController = TextEditingController();
  final TextEditingController paymentDateController = TextEditingController();
  final TextEditingController chequeNoController = TextEditingController();
  final List<String> paymentModes = ["cheque", "bank transfer", "credit card"];
  String selectedPaymentMode = "cheque";

  final String invoiceId;

  AddPaymentScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addPayment() {
      final newPayment = Payment(
        id: UniqueKey().toString(), // Generate a unique ID
        invoiceNo: invoiceId, // Replace with actual invoice ID
        amount: double.tryParse(amountController.text) ?? 0.0,
        paymentDate: paymentDateController.text,
        paymentMode: selectedPaymentMode,
        chequeNo: selectedPaymentMode == "cheque" ? int.tryParse(chequeNoController.text) : null,
      );

      // Add the payment to the state using Riverpod
      ref.read(paymentProvider.notifier).addPayment(newPayment);

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
                  paymentDateController.text = selectedDate.toString().split(' ')[0];
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
                selectedPaymentMode = value ?? "cheque";
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
              onPressed: addPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Add Payment",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
