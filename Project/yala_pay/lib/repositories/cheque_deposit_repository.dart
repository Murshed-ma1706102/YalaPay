import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/cheque_deposit.dart';

class ChequeDepositRepository {
  List<ChequeDeposit> _deposits = [];

  // Fetch all cheque deposits asynchronously from a data source
  Future<void> fetchAllAsync() async {
    try {
      // Load the JSON data from assets
      final String response = await rootBundle
          .loadString('assets/YalaPay-data/cheque-deposits.json');
      final List<dynamic> data = json.decode(response);

      // Parse the JSON data into a list of ChequeDeposit objects
      _deposits =
          data.map((jsonItem) => ChequeDeposit.fromJson(jsonItem)).toList();
    } catch (e) {
      print("Error loading cheque deposits: $e");
      _deposits = []; // Set to an empty list in case of an error
    }
  }

  // Get all deposits
  List<ChequeDeposit> getAll() {
    return _deposits;
  }

  // Add a new deposit
  void add(ChequeDeposit deposit) {
    _deposits.add(deposit);
    // Persist new deposit to data source if needed
  }

  // Update an existing deposit
  void update(String id, ChequeDeposit updatedDeposit) {
    final index = _deposits.indexWhere((deposit) => deposit.id == id);
    if (index != -1) {
      _deposits[index] = updatedDeposit;
      // Update deposit in data source if needed
    }
  }

  // Delete a deposit by ID
  void delete(String id) {
    _deposits.removeWhere((deposit) => deposit.id == id);
    // Remove deposit from data source if needed
  }
}
