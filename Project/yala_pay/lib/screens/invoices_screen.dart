import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/routes/app_router.dart';
import '../models/invoice.dart';
import 'package:intl/intl.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Invoice> _filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterInvoices);
    _filteredInvoices = ref.read(invoiceProvider); // Initialize with all invoices
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInvoices);
    _searchController.dispose();
    super.dispose();
  }

  void _filterInvoices() {
    final query = _searchController.text;
    setState(() {
      _filteredInvoices = ref.read(invoiceProvider.notifier).searchInvoices(query);
    });
  }


  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoiceProvider);

    
    

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
                  onPressed: () {context.goNamed('addInvoice');},
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
                ),
              ),
            ],
          ),
          Expanded(
            child: invoices.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchController.text.isEmpty
                        ? invoices.length
                        : _filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = _searchController.text.isEmpty
                          ? invoices[index]
                          : _filteredInvoices[index];
                      return InvoiceCard(
                        invoice: invoice,
                        onDelete: () {
                          ref.read(invoiceProvider.notifier).deleteInvoice(invoice.id);
                        },
                        onUpdate: () {
                          // Implement update logic here
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
  final Invoice invoice;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {

    final dateFormat = DateFormat('yyyy-MM-dd');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice #: ${invoice.id}",
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text("Customer ID: ${invoice.customerId}"),
                    Text("Amount: ${invoice.amount}"),
                    Text("Invoice Date: ${dateFormat.format(invoice.invoiceDate)}"),
                    Text("Due Date: ${dateFormat.format(invoice.dueDate)}"),
                    Text("Balance Pending: ${invoice.amount}"),
                  ],
                ),
              ),
              // Buttons in a column on the right
              Column(
                children: [
                  ElevatedButton(
                    onPressed: onUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 207, 252, 72),
                    ),
                    child: const Text(
                      "Update Invoice",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 170, 11, 0),
                    ),
                    child: const Text(
                      "Delete Invoice",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed('payments', pathParameters: {'invoiceId': invoice.id});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 123, 255),
                    ),
                    child: const Text(
                      "Show Payments",
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
