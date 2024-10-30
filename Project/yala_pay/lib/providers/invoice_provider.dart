import 'package:flutter/material.dart';
import '../repositories/invoice_repository.dart';
import '../models/invoice.dart';
import '../models/customer.dart';

class InvoiceProvider with ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  bool isLoading = true;
  List<Invoice> _userInvoices = [];

  // Load invoices based on a specific user's customers
  Future<void> initializeData(List<Customer> userCustomers) async {
    isLoading = true;
    notifyListeners();

    // Extract customer IDs
    List<String> customerIds =
        userCustomers.map((customer) => customer.id).toList();
    print("Customer IDs for filtering: $customerIds"); // Debug statement

    // Load all invoices and filter by customer IDs
    await _invoiceRepository.loadInvoicesFromJson();
    await _invoiceRepository.loadStatusesFromJson();
    _userInvoices = _invoiceRepository
        .getAll()
        .where((invoice) => customerIds.contains(invoice.customerId))
        .toList();

    print("Filtered invoices for user: $_userInvoices"); // Debug statement

    isLoading = false;
    notifyListeners();
  }

  // Accessors
  List<Invoice> get invoices => _userInvoices;
  List<String> get statuses => _invoiceRepository.getStatuses();

  // Helper methods for filtering by status
  List<Invoice> get unpaidInvoices =>
      _userInvoices.where((invoice) => invoice.status == "Unpaid").toList();
  List<Invoice> get partiallyPaidInvoices => _userInvoices
      .where((invoice) => invoice.status == "Partially Paid")
      .toList();
  List<Invoice> get paidInvoices =>
      _userInvoices.where((invoice) => invoice.status == "Paid").toList();

  Invoice? getInvoiceById(String id) {
    try {
      return _userInvoices.firstWhere((invoice) => invoice.id == id);
    } catch (e) {
      return null; // Returns null if no match is found
    }
  }

  void addInvoice(Invoice invoice) {
    _invoiceRepository.add(invoice);
    _userInvoices.add(invoice);
    notifyListeners();
  }

  void updateInvoiceStatus(String id, String newStatus) {
    final invoice = getInvoiceById(id);
    if (invoice != null && statuses.contains(newStatus)) {
      invoice.status = newStatus;
      notifyListeners();
    }
  }

  void deleteInvoice(String id) {
    _invoiceRepository.delete(id);
    _userInvoices.removeWhere((invoice) => invoice.id == id);
    notifyListeners();
  }
}
