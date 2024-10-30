import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              // Invoice Summary Section
              const Text('Invoices Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _buildSummaryCard(
                  'All', '99.99 QR', Icons.receipt_long, Colors.blue),
              _buildSummaryCard('Due Date in 30 days', '33.33 QR',
                  Icons.calendar_today, Colors.orange),
              _buildSummaryCard('Due Date in 60 days', '66.66 QR',
                  Icons.calendar_month, Colors.green),
              const SizedBox(height: 20),

              // Cheque Summary Section
              const Text('Cheques Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _buildSummaryCard(
                  'Awaiting', '99.99 QR', Icons.hourglass_empty, Colors.purple),
              _buildSummaryCard('Deposited', '22.22 QR', Icons.account_balance,
                  Colors.blueAccent),
              _buildSummaryCard('Cashed', '44.44 QR', Icons.money, Colors.teal),
              _buildSummaryCard('Returned', '11.11 QR', Icons.assignment_return,
                  Colors.redAccent),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a styled summary card
  Widget _buildSummaryCard(
      String label, String amount, IconData icon, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: Text(
          amount,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
