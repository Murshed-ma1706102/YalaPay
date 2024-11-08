import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/address.dart';
import 'package:yala_pay/models/contact_details.dart';
import '../models/customer.dart';

class CustomerNotifier extends StateNotifier<List<Customer>> {
  CustomerNotifier() : super([]) {
    loadCustomers();
  }

  // Load initial customers (you can modify this to load from JSON or API)
  Future<void> loadCustomers() async {
    try {
      // Load JSON data from the assets
      final String response = await rootBundle.loadString('assets/YalaPay-data/customers.json');
      final List<dynamic> data = json.decode(response);

      // Parse JSON data into a list of Invoice objects
      state = data.map((json) => Customer.fromJson(json)).toList();
    } catch (e) {
      print('Error loading invoices: $e');
      state = []; // Set state to empty list if loading fails
    }
  }

  // Add a new customer
  void addCustomer(Customer customer) {
    state = [...state, customer];
  }

  // Update an existing customer
  void updateCustomer(String id, Customer updatedCustomer) {
    state = [
      for (final customer in state)
        if (customer.id == id) updatedCustomer else customer,
    ];
  }

  // Delete a customer
  void deleteCustomer(String id) {
    state = state.where((customer) => customer.id != id).toList();
  }

  // Filter customers based on search query
  List<Customer> searchCustomers(String query) {
    if (query.isEmpty) return state;
    return state
        .where((customer) =>
            customer.companyName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Customer getCustomerById(String id) {
    return state.firstWhere((customer) => customer.id == id, orElse: () => throw Exception('Customer not found'));
  }
}

// Provider for accessing CustomerNotifier
final customerProvider = StateNotifierProvider<CustomerNotifier, List<Customer>>((ref) {
  return CustomerNotifier();
});
