import '../models/invoice.dart';
import 'base_repository.dart';

class InvoiceRepository implements BaseRepository<Invoice> {
  final List<Invoice> _invoices = [];

  @override
  List<Invoice> getAll() => _invoices;

  @override
  Invoice? getById(String id) {
    try {
      return _invoices.firstWhere((invoice) => invoice.id == id);
    } catch (e) {
      return null; // Return null if no invoice is found
    }
  }

  @override
  void add(Invoice invoice) {
    _invoices.add(invoice);
  }

  @override
  void update(String id, Invoice updatedInvoice) {
    final index = _invoices.indexWhere((invoice) => invoice.id == id);
    if (index != -1) _invoices[index] = updatedInvoice;
  }

  @override
  void delete(String id) {
    _invoices.removeWhere((invoice) => invoice.id == id);
  }
}
