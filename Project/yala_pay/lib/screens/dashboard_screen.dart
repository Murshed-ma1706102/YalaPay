// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Invoice Summary Section
              const Text(
                'Invoices Summary',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                'All',
                '99.99 QR',
                Icons.receipt_long,
                Colors.blue,
              ),
              _buildSummaryCard(
                'Due Date in 30 days',
                '33.33 QR',
                Icons.calendar_today,
                Colors.orange,
              ),
              _buildSummaryCard(
                'Due Date in 60 days',
                '66.66 QR',
                Icons.calendar_month,
                Colors.green,
              ),
              const SizedBox(height: 32),

              // Cheque Summary Section
              const Text(
                'Cheques Summary',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                'Awaiting',
                '99.99 QR',
                Icons.hourglass_empty,
                Colors.purple,
              ),
              _buildSummaryCard(
                'Deposited',
                '22.22 QR',
                Icons.account_balance,
                Colors.blueAccent,
              ),
              _buildSummaryCard(
                'Cashed',
                '44.44 QR',
                Icons.money,
                Colors.teal,
              ),
              _buildSummaryCard(
                'Returned',
                '11.11 QR',
                Icons.assignment_return,
                Colors.redAccent,
              ),
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
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
