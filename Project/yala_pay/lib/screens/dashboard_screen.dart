import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yala_pay/models/user.dart';
import '../providers/invoice_provider.dart';
import '../providers/cheque_provider.dart';
import '../providers/customer_provider.dart';
import '../models/invoice.dart';
import '../models/cheque.dart';

class DashboardScreen extends StatefulWidget {
  final User user; // User data received from the login screen

  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    // Load user-specific data for cheques and customers, then invoices
    Future.microtask(() {
      final chequeProvider =
          Provider.of<ChequeProvider>(context, listen: false);
      final customerProvider =
          Provider.of<CustomerProvider>(context, listen: false);
      final invoiceProvider =
          Provider.of<InvoiceProvider>(context, listen: false);

      chequeProvider.loadCheques(widget.user.firstName);

      // Load customers and then pass to invoiceProvider
      final userCustomers =
          customerProvider.getCustomersForUser(widget.user.firstName);
      invoiceProvider.initializeData(userCustomers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final chequeProvider = Provider.of<ChequeProvider>(context);

    if (invoiceProvider.isLoading || chequeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.user.firstName}"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Invoices',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Invoice Buttons
              _buildInvoiceButton(
                  context, 'All Invoices', invoiceProvider.invoices),
              const SizedBox(height: 10),
              _buildInvoiceButton(
                  context, 'Unpaid Invoices', invoiceProvider.unpaidInvoices),
              const SizedBox(height: 10),
              _buildInvoiceButton(context, 'Partially Paid Invoices',
                  invoiceProvider.partiallyPaidInvoices),
              const SizedBox(height: 10),
              _buildInvoiceButton(
                  context, 'Paid Invoices', invoiceProvider.paidInvoices),
              const SizedBox(height: 20),

              const Text('Cheques',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Cheque Buttons with filtering applied directly in the widget
              _buildChequeButton(
                  context,
                  'Cheque Awaiting',
                  chequeProvider.cheques
                      .where((c) => c.status == 'Awaiting')
                      .toList()),
              const SizedBox(height: 10),
              _buildChequeButton(
                  context,
                  'Cheque Deposited',
                  chequeProvider.cheques
                      .where((c) => c.status == 'Deposited')
                      .toList()),
              const SizedBox(height: 10),
              _buildChequeButton(
                  context,
                  'Cheque Cashed',
                  chequeProvider.cheques
                      .where((c) => c.status == 'Cashed')
                      .toList()),
              const SizedBox(height: 10),
              _buildChequeButton(
                  context,
                  'Cheque Returned',
                  chequeProvider.cheques
                      .where((c) => c.status == 'Returned')
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceButton(
      BuildContext context, String text, List<Invoice> invoices) {
    return ElevatedButton(
      onPressed: () {
        _showInvoicesDialog(context, text, invoices);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text('$text (${invoices.length})',
          style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildChequeButton(
      BuildContext context, String text, List<Cheque> cheques) {
    return ElevatedButton(
      onPressed: () {
        _showChequesDialog(context, text, cheques);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text('$text (${cheques.length})',
          style: const TextStyle(color: Colors.white)),
    );
  }

  void _showInvoicesDialog(
      BuildContext context, String title, List<Invoice> invoices) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return ListTile(
                title: Text(invoice.customerName),
                subtitle: Text(
                  'Amount: \$${invoice.amount.toStringAsFixed(2)}\nDue Date: ${invoice.dueDate.toLocal()}',
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChequesDialog(
      BuildContext context, String title, List<Cheque> cheques) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: cheques.length,
            itemBuilder: (context, index) {
              final cheque = cheques[index];
              return ListTile(
                title: Text(cheque.drawer),
                subtitle: Text(
                  'Amount: \$${cheque.amount.toStringAsFixed(2)}\n'
                  'Bank: ${cheque.bankName}\n'
                  'Status: ${cheque.status}\n'
                  'Received: ${cheque.receivedDate.toLocal()}\n'
                  'Due Date: ${cheque.dueDate.toLocal()}',
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
