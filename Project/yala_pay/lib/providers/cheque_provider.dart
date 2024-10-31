import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/cheque_repository.dart';
import '../models/cheque.dart';

class ChequeNotifier extends StateNotifier<List<Cheque>> {
  final ChequeRepository _chequeRepository;

  ChequeNotifier(this._chequeRepository) : super([]) {
    loadCheques();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadCheques() async {
    _isLoading = true;
    try {
      await _chequeRepository.fetchAllAsync();
      state = _chequeRepository.getAll();
    } catch (e) {
      print("Error loading cheques: $e");
      state = [];
    } finally {
      _isLoading = false;
    }
  }

  Cheque? getChequeByNumber(int chequeNo) {
    try {
      return state.firstWhere((cheque) => cheque.chequeNo == chequeNo);
    } catch (e) {
      // Return null if no matching cheque is found
      return null;
    }
  }

  void addCheque(Cheque cheque) {
    _chequeRepository.add(cheque);
    state = [...state, cheque];
  }

  void updateCheque(int chequeNo, Cheque updatedCheque) {
    state = [
      for (final cheque in state)
        if (cheque.chequeNo == chequeNo) updatedCheque else cheque,
    ];
    _chequeRepository.update(chequeNo, updatedCheque);
  }

  void deleteCheque(int chequeNo) {
    state = state.where((cheque) => cheque.chequeNo != chequeNo).toList();
    _chequeRepository.delete(chequeNo);
  }
}

final chequeProvider = StateNotifierProvider<ChequeNotifier, List<Cheque>>(
  (ref) => ChequeNotifier(ChequeRepository()),
);
