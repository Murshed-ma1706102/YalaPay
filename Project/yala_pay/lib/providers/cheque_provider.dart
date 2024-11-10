import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cheque.dart';

class ChequeNotifier extends StateNotifier<List<Cheque>> {
  ChequeNotifier() : super([]);

  // Load initial cheques (you can load from assets or any data source)
  Future<void> loadInitialCheques() async {
    try {
      final String response = await rootBundle.loadString('assets/YalaPay-data/cheques.json');
      final List<dynamic> data = json.decode(response);
      state = data.map((json) => Cheque.fromJson(json)).toList();
    } catch (e) {
      print('Error loading cheques: $e');
      state = [];
    }
  }

  // Add a new cheque
  void addCheque(Cheque cheque) {
    state = [...state, cheque];
  }

  // Update an existing cheque
  void updateCheque(int chequeNo, Cheque updatedCheque) {
    state = [
      for (final cheque in state)
        if (cheque.chequeNo == chequeNo) updatedCheque else cheque,
    ];
  }

  // Delete a cheque by chequeNo
  void deleteCheque(int chequeNo) {
    state = state.where((cheque) => cheque.chequeNo != chequeNo).toList();
  }

  // Get a cheque by chequeNo
  Cheque getChequeByChequeNo(int chequeNo) {
    return state.firstWhere((cheque) => cheque.chequeNo == chequeNo, orElse: () => throw Exception('Cheque not found'));
  }
}

final chequeProvider = StateNotifierProvider<ChequeNotifier, List<Cheque>>((ref) {
  return ChequeNotifier()..loadInitialCheques();
});
