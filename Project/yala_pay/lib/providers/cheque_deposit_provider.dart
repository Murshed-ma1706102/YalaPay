import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/cheque_deposit_repository.dart';
import '../models/cheque_deposit.dart';

class ChequeDepositNotifier extends StateNotifier<List<ChequeDeposit>> {
  final ChequeDepositRepository _chequeDepositRepository;

  ChequeDepositNotifier(this._chequeDepositRepository) : super([]) {
    loadDeposits();
  }

  bool _isLoading = false;
  final Map<String, Map<String, dynamic>> _depositDetails = {};

  bool get isLoading => _isLoading;

  Future<void> loadDeposits() async {
    _isLoading = true;
    try {
      await _chequeDepositRepository.fetchAllAsync();
      state = _chequeDepositRepository.getAll();
    } catch (e) {
      print("Error loading deposits: $e");
      state = [];
    } finally {
      _isLoading = false;
    }
  }

  ChequeDeposit? getDepositById(String id) {
    try {
      return state.firstWhere((deposit) => deposit.id == id);
    } catch (e) {
      // Return null if no match is found
      return null;
    }
  }

  void addDeposit(ChequeDeposit deposit) {
    _chequeDepositRepository.add(deposit);
    state = [...state, deposit];
  }

  void updateDeposit(String id, ChequeDeposit updatedDeposit) {
    state = [
      for (final deposit in state)
        if (deposit.id == id) updatedDeposit else deposit,
    ];
    _chequeDepositRepository.update(id, updatedDeposit);
  }

  void deleteDeposit(String id) {
    state = state.where((deposit) => deposit.id != id).toList();
    _chequeDepositRepository.delete(id);
  }

  void updateDepositStatus(String depositId, String status,
      {DateTime? cashedDate, DateTime? returnDate, String? returnReason}) {
    final updatedDeposits = state.map((deposit) {
      if (deposit.id == depositId) {
        deposit.status = status;
        _depositDetails[depositId] = {
          'cashedDate': cashedDate,
          'returnDate': returnDate,
          'returnReason': returnReason,
        };
      }
      return deposit;
    }).toList();
    state = updatedDeposits;
  }

  Map<String, dynamic>? getDepositDetails(String depositId) {
    return _depositDetails[depositId];
  }
}

final chequeDepositProvider =
    StateNotifierProvider<ChequeDepositNotifier, List<ChequeDeposit>>(
  (ref) => ChequeDepositNotifier(ChequeDepositRepository()),
);
