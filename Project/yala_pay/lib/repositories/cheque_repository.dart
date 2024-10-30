import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/cheque.dart';

class ChequeRepository {
  late List<Cheque> _cheques = [];

  // Fetch all cheques asynchronously from a data source
  Future<void> fetchAllAsync() async {
    try {
      // Load the JSON data from the assets
      final String response =
          await rootBundle.loadString('assets/YalaPay-data/cheques.json');
      final List<dynamic> data = json.decode(response);

      // Parse the JSON data into a list of Cheque objects
      _cheques = data.map((jsonItem) => Cheque.fromJson(jsonItem)).toList();
    } catch (e) {
      print("Error loading cheques: $e");
      _cheques = []; // Set to an empty list in case of an error
    }
  }

  // Get all cheques
  List<Cheque> getAll() {
    return _cheques;
  }

  // Add a new cheque
  void add(Cheque cheque) {
    _cheques.add(cheque);
    // Persist new cheque to data source if needed
  }

  // Update an existing cheque
  void update(int chequeNo, Cheque updatedCheque) {
    final index = _cheques.indexWhere((cheque) => cheque.chequeNo == chequeNo);
    if (index != -1) {
      _cheques[index] = updatedCheque;
      // Update cheque in data source if needed
    }
  }

  // Delete a cheque by cheque number
  void delete(int chequeNo) {
    _cheques.removeWhere((cheque) => cheque.chequeNo == chequeNo);
    // Remove cheque from data source if needed
  }
}
