import 'package:flutter/material.dart';
import '../repositories/cheque_deposit_repository.dart';
import '../models/cheque_deposit.dart';

class ChequeDepositProvider with ChangeNotifier {
  final ChequeDepositRepository _chequeDepositRepository =
      ChequeDepositRepository();

  bool _isLoading = false;

  List<ChequeDeposit> _chequeDeposits = [];
  List<ChequeDeposit> get chequeDeposits => _chequeDeposits;

  bool get isLoading => _isLoading;

  Future<void> loadInitialData(List<ChequeDeposit> deposits) async {
    _isLoading = true;
    notifyListeners();

    _chequeDeposits = deposits;
    _chequeDepositRepository.loadInitialData(deposits);

    _isLoading = false;
    notifyListeners();
  }

  ChequeDeposit? getChequeDepositById(String id) {
    return _chequeDepositRepository.getById(id);
  }

  Future<void> addChequeDeposit(ChequeDeposit deposit) async {
    _chequeDepositRepository.add(deposit);
    _chequeDeposits.add(deposit);
    notifyListeners();
  }

  Future<void> updateChequeDeposit(
      String id, ChequeDeposit updatedDeposit) async {
    _chequeDepositRepository.update(id, updatedDeposit);
    final index = _chequeDeposits.indexWhere((d) => d.id == id);
    if (index != -1) {
      _chequeDeposits[index] = updatedDeposit;
      notifyListeners();
    }
  }

  Future<void> deleteChequeDeposit(String id) async {
    _chequeDepositRepository.delete(id);
    _chequeDeposits.removeWhere((deposit) => deposit.id == id);
    notifyListeners();
  }

  List<ChequeDeposit> getDepositsByStatus(String status) {
    return _chequeDepositRepository.getByStatus(status);
  }
}
