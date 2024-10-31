import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/providers/new_invoice_provider.dart';
import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoicesScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

   InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(invoiceProvider);
    final invoiceNotifier = ref.read(invoiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoices"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to add invoice screen or open a dialog
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "Add Invoice",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Invoices...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (query) {
                    ref.refresh(invoiceProvider);
                    final searchResults = invoiceNotifier.searchInvoices(query);
                    // Optionally handle the search results here
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: invoices.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return InvoiceCard(
                        invoiceId: invoice.id,
                        customerId: invoice.customerId,
                        amount: invoice.amount,
                        invoiceDate: invoice.invoiceDate,
                        dueDate: invoice.dueDate,
                        balancePending: invoice.amount,
                        onDelete: () {
                          invoiceNotifier.deleteInvoice(invoice.id);
                        },
                        onUpdate: () {
                          // Implement navigation to update screen or open a dialog
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final String invoiceId;
  final String customerId;
  final double amount;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final double balancePending;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const InvoiceCard({
    super.key,
    required this.invoiceId,
    required this.customerId,
    required this.amount,
    required this.invoiceDate,
    required this.dueDate,
    required this.balancePending,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Invoice #: $invoiceId",
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text("Customer ID: $customerId"),
              Text("Amount: $amount"),
              Text("Invoice Date: ${invoiceDate.toLocal()}".split(' ')[0]),
              Text("Due Date: ${dueDate.toLocal()}".split(' ')[0]),
              Text("Balance Pending: $balancePending"),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onUpdate,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 207, 252, 72)),
                    child: const Text(
                      "Update Invoice",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 170, 11, 0)),
                    child: const Text(
                      "Delete Invoice",
                      style: TextStyle(color: Colors.white),
                    ),
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
