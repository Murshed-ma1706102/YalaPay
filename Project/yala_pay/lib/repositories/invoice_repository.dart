import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/invoice.dart';
import 'base_repository.dart';

class InvoiceRepository implements BaseRepository<Invoice> {
  final List<Invoice> _invoices = [];
  List<String> _statuses = [];

  Future<void> loadInvoicesFromJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/YalaPay-data/invoices.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _invoices.clear();
      _invoices.addAll(jsonData.map((data) => Invoice.fromJson(data)).toList());
      print(
          "Loaded invoices: $_invoices"); // Debug statement to verify loaded data
    } catch (e) {
      print("Error loading invoices: $e");
    }
  }

  Future<void> loadStatusesFromJson() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/YalaPay-data/invoice-status.json');
      _statuses = List<String>.from(json.decode(jsonString));
      print(
          "Loaded statuses: $_statuses"); // Debug statement to verify loaded statuses
    } catch (e) {
      print("Error loading statuses: $e");
    }
  }

  List<Invoice> getAll() => _invoices;
  List<String> getStatuses() => _statuses;

  Invoice? getById(String id) {
    try {
      return _invoices.firstWhere((invoice) => invoice.id == id);
    } catch (e) {
      return null;
    }
  }

  void add(Invoice invoice) {
    _invoices.add(invoice);
  }

  void update(String id, Invoice updatedInvoice) {
    final index = _invoices.indexWhere((invoice) => invoice.id == id);
    if (index != -1) _invoices[index] = updatedInvoice;
  }

  void delete(String id) {
    _invoices.removeWhere((invoice) => invoice.id == id);
  }
}
