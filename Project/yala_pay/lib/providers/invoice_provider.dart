import 'package:flutter/material.dart';
import '../repositories/invoice_repository.dart';
import '../models/invoice.dart';

class InvoiceProvider with ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();

  List<Invoice> get invoices => _invoiceRepository.getAll();

  Invoice? getInvoiceById(String id) {
    return _invoiceRepository.getById(id);
  }

  void addInvoice(Invoice invoice) {
    _invoiceRepository.add(invoice);
    notifyListeners();
  }

  void updateInvoice(String id, Invoice updatedInvoice) {
    _invoiceRepository.update(id, updatedInvoice);
    notifyListeners();
  }

  void deleteInvoice(String id) {
    _invoiceRepository.delete(id);
    notifyListeners();
  }
}
