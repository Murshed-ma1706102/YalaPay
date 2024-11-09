import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import '../models/invoice.dart';

class UpdateInvoiceScreen extends ConsumerWidget {
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  final String invoiceId;

  UpdateInvoiceScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final invoice = ref.watch(invoiceProvider.notifier).getInvoiceById(invoiceId);

    final TextEditingController customerIdController = TextEditingController(text: invoice.customerId);
    final TextEditingController customerNameController = TextEditingController(text: invoice.customerName);
    final TextEditingController amountController = TextEditingController(text: invoice.amount.toString());
    final TextEditingController statusController = TextEditingController(text: invoice.status);


    void updateInvoice() {
      final newInvoice = Invoice(
        id: invoiceId, // Generate a unique ID
        customerId: customerIdController.text,
        customerName: customerNameController.text,
        amount: double.tryParse(amountController.text) ?? 0.0,
        invoiceDate: DateTime.now(), // Set invoice date to today by default
        dueDate: DateTime.now()
            .add(Duration(days: 30)), // Default due date 30 days from now
        status:
            statusController.text.isNotEmpty ? statusController.text : "Unpaid",
      );

      // Add the invoice to the state using Riverpod
      ref.read(invoiceProvider.notifier).updateInvoice(invoiceId, newInvoice);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('invoice updated successfully!'),
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

      // Navigate back to the invoice list screen
      context.goNamed('invoices');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Invoice"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              const Text(
                "Invoice Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: customerIdController,
                decoration: const InputDecoration(
                  labelText: "Customer ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_box),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter customer ID" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: customerNameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter customer name" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter status (optional)" : null,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: updateInvoice,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Update Invoice",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
