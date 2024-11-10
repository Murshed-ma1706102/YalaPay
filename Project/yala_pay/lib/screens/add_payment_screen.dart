import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/providers/bank_provider.dart';
import 'package:yala_pay/providers/cheque_provider.dart';
import 'package:yala_pay/providers/payments_provider.dart';
import 'package:yala_pay/providers/mode_payment_provider.dart';
import '../models/payment.dart';
import '../models/cheque.dart';

class AddPaymentScreen extends ConsumerWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController paymentDateController = TextEditingController();
  final TextEditingController chequeNoController = TextEditingController();
  final TextEditingController chequeDrawerController = TextEditingController();
  final TextEditingController chequeDrawerBankController = TextEditingController();
  final TextEditingController chequeStatusController = TextEditingController();
  final TextEditingController chequeImageController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();  // New Controller for Due Date

  final List<String> paymentModes = ["cheque", "bank transfer", "credit card"];
  String selectedPaymentMode = "cheque";
  String? selectedBank;  // variable that will hold the selected bank

  final String invoiceId;

  AddPaymentScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMode = ref.watch(paymentModeProvider);
    final bankListAsync = ref.watch(bankListProvider);

    // Add Payment Function
    void addPayment() {
      // Create Payment object
      final newPayment = Payment(
        id: UniqueKey().toString(), // Generate a unique ID
        invoiceNo: invoiceId, // Replace with actual invoice ID
        amount: double.tryParse(amountController.text) ?? 0.0,
        paymentDate: paymentDateController.text,
        paymentMode: selectedPaymentMode,
        chequeNo: selectedPaymentMode == "cheque"
            ? int.tryParse(chequeNoController.text)
            : null,
      );

      // Add the payment to the state using Riverpod
      ref.read(paymentProvider.notifier).addPayment(newPayment);

      // If the payment is via cheque, create and add a Cheque object
      if (selectedPaymentMode == "cheque") {
        final cheque = Cheque(
          chequeNo: int.tryParse(chequeNoController.text) ?? 0,
          amount: newPayment.amount,
          drawer: chequeDrawerController.text,
          bankName: chequeDrawerBankController.text,
          status: "Awaiting", // Default status for cheque payments
          receivedDate: DateTime.now(), // Default to today’s date for cheque
          dueDate: DateTime.tryParse(dueDateController.text) ?? DateTime.now().add(Duration(days: 30)), // Use selected or default due date
          chequeImageUri: chequeImageController.text, 
        );

        // Add the cheque to the cheques list
        ref.read(chequeProvider.notifier).addCheque(cheque);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment added successfully!'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
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
                if (value != null) {
                  ref.read(paymentModeProvider.notifier).state = value;
                }
              },
            ),
            const SizedBox(height: 16.0),
            if (selectedPaymentMode == "cheque") ...[
              TextFormField(
                controller: chequeNoController,
                decoration: const InputDecoration(
                  labelText: "Cheque No",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: chequeDrawerController,
                decoration: const InputDecoration(
                  labelText: "Drawer",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_box),
                ),
              ),
              const SizedBox(height: 16.0),
               bankListAsync.when(
                data: (bankList) {
                  return DropdownButtonFormField<String>(
                    value: selectedBank,
                    decoration: const InputDecoration(
                      labelText: "Drawer Bank",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: bankList.map((bank) {
                      return DropdownMenuItem(
                        value: bank,
                        child: Text(bank),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedBank = value; // Set the selected bank
                      }
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error loading banks: $error'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: chequeImageController,
                decoration: const InputDecoration(
                  labelText: "Cheque Image URL",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 16.0),
              // New Date Picker for Due Date
              TextFormField(
                controller: dueDateController,
                decoration: const InputDecoration(
                  labelText: "Due Date",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 30)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    dueDateController.text =
                        selectedDate.toString().split(' ')[0];
                  }
                },
              ),
            ],
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
