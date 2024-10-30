import 'package:flutter/material.dart';
import '../repositories/cheque_deposit_repository.dart';
import '../models/cheque_deposit.dart';

class ChequeDepositProvider with ChangeNotifier {
  final ChequeDepositRepository _chequeDepositRepository =
      ChequeDepositRepository();

  List<ChequeDeposit> _deposits = [];
  bool _isLoading = false;

  // Getter to access the deposit list
  List<ChequeDeposit> get deposits => _deposits;
  bool get isLoading => _isLoading;

  // Load deposits asynchronously
  Future<void> loadDeposits() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _chequeDepositRepository
          .fetchAllAsync(); // Load data from repository
      _deposits = _chequeDepositRepository.getAll(); // Update local list
    } catch (e) {
      print("Error loading deposits: $e");
      _deposits = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieve a deposit by ID
  ChequeDeposit? getDepositById(String id) {
    try {
      return _deposits.firstWhere((deposit) => deposit.id == id);
    } catch (e) {
      return null; // Return null if no matching deposit is found
    }
  }

  // Add a new deposit
  void addDeposit(ChequeDeposit deposit) {
    _chequeDepositRepository.add(deposit);
    _deposits.add(deposit);
    notifyListeners();
  }

  // Update an existing deposit
  void updateDeposit(String id, ChequeDeposit updatedDeposit) {
    final index = _deposits.indexWhere((deposit) => deposit.id == id);
    if (index != -1) {
      _deposits[index] = updatedDeposit;
      _chequeDepositRepository.update(id, updatedDeposit);
      notifyListeners();
    }
  }

  // Delete a deposit
  void deleteDeposit(String id) {
    _deposits.removeWhere((deposit) => deposit.id == id);
    _chequeDepositRepository.delete(id);
    notifyListeners();
  }
}
