import 'package:flutter/material.dart';
import '../repositories/cheque_repository.dart';
import '../models/cheque.dart';

class ChequeProvider with ChangeNotifier {
  final ChequeRepository _chequeRepository = ChequeRepository();

  bool _isLoading = false;
  List<Cheque> _cheques = [];
  List<Cheque> get cheques => _cheques;

  bool get isLoading => _isLoading;

  // Load cheques for a specific user based on firstName
  Future<void> loadCheques(String firstName) async {
    _isLoading = true;
    notifyListeners();

    // Fetch all cheques and filter by `drawer`
    _cheques = await _chequeRepository.fetchAllAsync();
    _cheques = _cheques.where((cheque) => cheque.drawer == firstName).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<Cheque?> getChequeByNo(String chequeNo) async {
    return await _chequeRepository.fetchByIdAsync(chequeNo);
  }

  Future<void> addCheque(Cheque cheque) async {
    await _chequeRepository.addAsync(cheque);
    _cheques.add(cheque);
    notifyListeners();
  }

  Future<void> updateCheque(String chequeNo, Cheque updatedCheque) async {
    await _chequeRepository.updateAsync(chequeNo, updatedCheque);
    final index = _cheques.indexWhere((c) => c.chequeNo.toString() == chequeNo);
    if (index != -1) {
      _cheques[index] = updatedCheque;
      notifyListeners();
    }
  }

  Future<void> deleteCheque(String chequeNo) async {
    await _chequeRepository.deleteAsync(chequeNo);
    _cheques.removeWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
    notifyListeners();
  }
}
