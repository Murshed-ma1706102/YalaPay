import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/invoice.dart';
import 'package:yala_pay/providers/invoice_provider.dart';

class InvoicesReportScreen extends ConsumerStatefulWidget {
  const InvoicesReportScreen({super.key});

  @override
  ConsumerState<InvoicesReportScreen> createState() =>
      _InvoicesReportScreenState();
}

class _InvoicesReportScreenState extends ConsumerState<InvoicesReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  String selectedStatus = "All";
  final List<String> statuses = ["All", "Pending", "Partially Paid", "Paid"];
  List<Invoice> filteredInvoices = [];

  void pickDateRange() async {
    final DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dateRange != null) {
      setState(() {
        fromDate = dateRange.start;
        toDate = dateRange.end;
      });
    }
  }

  void generateReport() {
    filteredInvoices =
        ref.read(invoiceProvider.notifier).getInvoicesByDateAndStatus(
              fromDate: fromDate,
              toDate: toDate,
              status: selectedStatus,
            );

    setState(() {
      filteredInvoices = filteredInvoices; // Refresh UI with new data
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalInvoices = filteredInvoices.length;
    final totalAmount = filteredInvoices.fold<double>(
      0,
      (sum, invoice) => sum + invoice.amount,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Invoices Report",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Date Range Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: pickDateRange,
                  child: Text(
                    fromDate == null || toDate == null
                        ? "Select Date Range"
                        : "${fromDate!.toLocal()} - ${toDate!.toLocal()}"
                            .split(' ')[0],
                  ),
                ),
                DropdownButton<String>(
                  value: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  items: statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Generate Report and Navigate Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: generateReport,
                  child: const Text("Generate Report"),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/chequeFilter');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Cheques Report"),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Report Results
            if (filteredInvoices.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = filteredInvoices[index];
                    final balance = invoice.amount;
                    return Card(
                      child: ListTile(
                        title: Text("Invoice #: ${invoice.id}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Amount: ${invoice.amount}"),
                            Text("Balance Pending: $balance"),
                            Text("Status: ${invoice.status}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Totals
            if (selectedStatus == "All" && filteredInvoices.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Text("Totals by Status",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  "Pending: ${filteredInvoices.where((i) => i.status == "Pending").length} invoices"),
              Text(
                  "Partially Paid: ${filteredInvoices.where((i) => i.status == "Partially Paid").length} invoices"),
              Text(
                  "Paid: ${filteredInvoices.where((i) => i.status == "Paid").length} invoices"),
              const Divider(),
              Text("Grand Total: $totalAmount for $totalInvoices invoices"),
            ],
          ],
        ),
      ),
    );
  }
}
