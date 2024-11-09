import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment.dart';

class PaymentNotifier extends StateNotifier<List<Payment>> {
  PaymentNotifier() : super([]);

  // Load initial payments for demonstration purposes
  Future<void> loadInitialPayments() async {
    try {
      // Load JSON data from the assets
      final String response = await rootBundle.loadString('assets/YalaPay-data/payments.json');
      final List<dynamic> data = json.decode(response);

      // Parse JSON data into a list of Invoice objects
      state = data.map((json) => Payment.fromJson(json)).toList();
    } catch (e) {
      print('Error loading payments: $e');
      state = []; // Set state to empty list if loading fails
    }
  }

  Payment getPaymentById(String id) {
    return state.firstWhere((payment) => payment.id == id, orElse: () => throw Exception('Payment not found'));
  }

  // Add a new payment
  void addPayment(Payment payment) {
    state = [...state, payment];
  }

  // Update an existing payment
  void updatePayment(String paymentId, Payment updatedPayment) {
    state = [
      for (final payment in state)
        if (payment.id == paymentId) updatedPayment else payment,
    ];
  }

  // Delete a payment by ID
  void deletePayment(String paymentId) {
    state = state.where((payment) => payment.id != paymentId).toList();
  }

  // Get payments for a specific invoice
  List<Payment> getPaymentsForInvoice(String invoiceNo) {
    return state.where((payment) => payment.invoiceNo == invoiceNo).toList();
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, List<Payment>>((ref) {
  return PaymentNotifier()..loadInitialPayments();
});
