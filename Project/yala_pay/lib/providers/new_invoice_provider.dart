import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice.dart';

class InvoiceNotifier extends StateNotifier<List<Invoice>> {
  InvoiceNotifier() : super([]) {
    loadInvoices();
  }

  // Load invoices from a JSON file or an API
  Future<void> loadInvoices() async {
     try {
      // Load JSON data from the assets
      final String response = await rootBundle.loadString('assets/YalaPay-data/invoices.json');
      final List<dynamic> data = json.decode(response);

      // Parse JSON data into a list of Invoice objects
      state = data.map((json) => Invoice.fromJson(json)).toList();
    } catch (e) {
      print('Error loading invoices: $e');
      state = []; // Set state to empty list if loading fails
    }
  }

  // Add a new invoice
  void addInvoice(Invoice invoice) {
    state = [...state, invoice];
  }

  // Update an existing invoice
  void updateInvoice(String invoiceId, Invoice updatedInvoice) {
    state = [
      for (final invoice in state)
        if (invoice.id == invoiceId) updatedInvoice else invoice,
    ];
  }

  // Delete an invoice
  void deleteInvoice(String invoiceId) {
    state = state.where((invoice) => invoice.id != invoiceId).toList();
  }

  // Search for invoices by invoice number
  List<Invoice> searchInvoices(String query) {
    return state
        .where((invoice) =>
            invoice.id.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

// Provide an instance of InvoiceNotifier
final invoiceProvider = StateNotifierProvider<InvoiceNotifier, List<Invoice>>((ref) {
  return InvoiceNotifier();
});