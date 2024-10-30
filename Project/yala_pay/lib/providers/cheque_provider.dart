import 'package:flutter/material.dart';
import '../repositories/cheque_repository.dart';
import '../models/cheque.dart';

class ChequeProvider with ChangeNotifier {
  final ChequeRepository _chequeRepository = ChequeRepository();

  List<Cheque> _cheques = [];
  bool _isLoading = false;

  // Getter to access the cheque list
  List<Cheque> get cheques => _cheques;
  bool get isLoading => _isLoading;

  // Load cheques asynchronously
  Future<void> loadCheques() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _chequeRepository.fetchAllAsync(); // Load data from repository
      _cheques = _chequeRepository.getAll(); // Update local list
    } catch (e) {
      print("Error loading cheques: $e");
      _cheques = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieve a cheque by its number
  Cheque? getChequeByNumber(int chequeNo) {
    try {
      return _cheques.firstWhere((cheque) => cheque.chequeNo == chequeNo);
    } catch (e) {
      return null; // Return null if no matching cheque is found
    }
  }

  // Add a new cheque
  void addCheque(Cheque cheque) {
    _chequeRepository.add(cheque);
    _cheques.add(cheque);
    notifyListeners();
  }

  // Update an existing cheque
  void updateCheque(int chequeNo, Cheque updatedCheque) {
    final index = _cheques.indexWhere((cheque) => cheque.chequeNo == chequeNo);
    if (index != -1) {
      _cheques[index] = updatedCheque;
      _chequeRepository.update(chequeNo, updatedCheque);
      notifyListeners();
    }
  }

  // Delete a cheque
  void deleteCheque(int chequeNo) {
    _cheques.removeWhere((cheque) => cheque.chequeNo == chequeNo);
    _chequeRepository.delete(chequeNo);
    notifyListeners();
  }
}
