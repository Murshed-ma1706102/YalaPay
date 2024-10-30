import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/customer.dart';
import 'base_repository.dart';

class CustomerRepository implements BaseRepository<Customer> {
  final List<Customer> _customers = [];

  @override
  List<Customer> getAll() => _customers;

  @override
  Customer? getById(String id) {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null; // Return null if no customer is found
    }
  }

  @override
  void add(Customer customer) {
    _customers.add(customer);
  }

  @override
  void update(String id, Customer updatedCustomer) {
    final index = _customers.indexWhere((customer) => customer.id == id);
    if (index != -1) _customers[index] = updatedCustomer;
  }

  @override
  void delete(String id) {
    _customers.removeWhere((customer) => customer.id == id);
  }

  Future<void> fetchAllAsync() async {
    try {
      // Load JSON data from the assets
      final String response =
          await rootBundle.loadString('assets/YalaPay-data/customers.json');
      final List<dynamic> data = json.decode(response);

      // Parse JSON data and populate the _customers list
      _customers.clear();
      _customers.addAll(data.map((json) => Customer.fromJson(json)).toList());
    } catch (e) {
      print("Error fetching customers: $e");
    }
  }
}
