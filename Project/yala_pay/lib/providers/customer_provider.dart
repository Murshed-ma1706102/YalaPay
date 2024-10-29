import 'package:flutter/material.dart';
import '../repositories/customer_repository.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _customerRepository = CustomerRepository();

  List<Customer> get customers => _customerRepository.getAll();

  Customer? getCustomerById(String id) {
    return _customerRepository.getById(id);
  }

  void addCustomer(Customer customer) {
    _customerRepository.add(customer);
    notifyListeners();
  }

  void updateCustomer(String id, Customer updatedCustomer) {
    _customerRepository.update(id, updatedCustomer);
    notifyListeners();
  }

  void deleteCustomer(String id) {
    _customerRepository.delete(id);
    notifyListeners();
  }
}
