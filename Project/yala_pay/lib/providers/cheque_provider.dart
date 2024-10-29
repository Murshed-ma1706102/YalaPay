import 'package:flutter/material.dart';
import '../repositories/cheque_repository.dart';
import '../models/cheque.dart';

class ChequeProvider with ChangeNotifier {
  final ChequeRepository _chequeRepository = ChequeRepository();

  List<Cheque> get cheques => _chequeRepository.getAll();

  Cheque? getChequeByNo(String chequeNo) {
    return _chequeRepository.getById(chequeNo);
  }

  void addCheque(Cheque cheque) {
    _chequeRepository.add(cheque);
    notifyListeners();
  }

  void updateCheque(String chequeNo, Cheque updatedCheque) {
    _chequeRepository.update(chequeNo, updatedCheque);
    notifyListeners();
  }

  void deleteCheque(String chequeNo) {
    _chequeRepository.delete(chequeNo);
    notifyListeners();
  }
}
