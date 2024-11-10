import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import '../models/invoice.dart';

class AddInvoiceScreen extends ConsumerWidget {
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  AddInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addInvoice() {
      final newInvoice = Invoice(
        id: ref.watch(invoiceProvider.notifier).getNextInvoiceId().toString(), // Generate a unique ID
        customerId: customerIdController.text,
        customerName: customerNameController.text,
        amount: double.tryParse(amountController.text) ?? 0.0,
        invoiceDate: DateTime.now(), // Set invoice date to today by default
        dueDate: DateTime.now().add(Duration(days: 30)), // Default due date 30 days from now
        status: statusController.text.isNotEmpty ? statusController.text : "Unpaid",
      );

      // Add the invoice to the state using Riverpod
      ref.read(invoiceProvider.notifier).addInvoice(newInvoice);

      // Navigate back to the invoice list screen
      context.goNamed('invoices');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Invoice"),
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
                validator: (value) => value!.isEmpty ? "Enter customer ID" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: customerNameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? "Enter customer name" : null,
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
                validator: (value) => value!.isEmpty ? "Enter status (optional)" : null,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: addInvoice,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Add Invoice",
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
