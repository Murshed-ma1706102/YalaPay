import 'package:flutter/material.dart';
import '../repositories/cheque_deposit_repository.dart';
import '../models/cheque_deposit.dart';

class ChequeDepositProvider with ChangeNotifier {
  final ChequeDepositRepository _chequeDepositRepository =
      ChequeDepositRepository();

  List<ChequeDeposit> get chequeDeposits => _chequeDepositRepository.getAll();

  ChequeDeposit? getChequeDepositById(String id) {
    return _chequeDepositRepository.getById(id);
  }

  void addChequeDeposit(ChequeDeposit deposit) {
    _chequeDepositRepository.add(deposit);
    notifyListeners();
  }

  void updateChequeDeposit(String id, ChequeDeposit updatedDeposit) {
    _chequeDepositRepository.update(id, updatedDeposit);
    notifyListeners();
  }

  void deleteChequeDeposit(String id) {
    _chequeDepositRepository.delete(id);
    notifyListeners();
  }

  List<ChequeDeposit> getDepositsByStatus(String status) {
    return _chequeDepositRepository.getByStatus(status);
  }
}
