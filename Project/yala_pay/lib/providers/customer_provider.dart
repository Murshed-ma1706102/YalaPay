import 'package:flutter/material.dart';
import '../repositories/customer_repository.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _customerRepository = CustomerRepository();

  List<Customer> _customers = [];
  bool _isLoading = false;

  // Getter to access the customer list
  List<Customer> get customers => _customers;

  bool get isLoading => _isLoading;

  // Initialize or refresh customer data asynchronously
  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _customerRepository
          .fetchAllAsync(); // Populate _customers in repository
      _customers = _customerRepository.getAll(); // Update provider's local list
    } catch (e) {
      print("Error loading customers: $e");
      _customers = []; // Clear customer list in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieve a customer by ID
  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null; // Return null if no matching customer is found
    }
  }

  // Add a new customer
  void addCustomer(Customer customer) {
    _customerRepository.add(customer);
    _customers.add(customer);
    notifyListeners();
  }

  // Update an existing customer
  void updateCustomer(String id, Customer updatedCustomer) {
    final index = _customers.indexWhere((customer) => customer.id == id);
    if (index != -1) {
      _customers[index] = updatedCustomer;
      _customerRepository.update(id, updatedCustomer);
      notifyListeners();
    }
  }

  // Delete a customer
  void deleteCustomer(String id) {
    _customers.removeWhere((customer) => customer.id == id);
    _customerRepository.delete(id);
    notifyListeners();
  }

  // Retrieve customers associated with a specific user by their first name
  List<Customer> getCustomersForUser(String userName) {
    final matchingCustomers = _customers
        .where((customer) => customer.contactDetails.firstName == userName)
        .toList();
    print(
        "Matching customers for user $userName: $matchingCustomers"); // Debug statement
    return matchingCustomers;
  }
}
