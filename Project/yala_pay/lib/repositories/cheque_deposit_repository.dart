import '../models/cheque_deposit.dart';
import 'base_repository.dart';

class ChequeDepositRepository implements BaseRepository<ChequeDeposit> {
  final List<ChequeDeposit> _chequeDeposits = [];

  @override
  List<ChequeDeposit> getAll() => _chequeDeposits;

  @override
  ChequeDeposit? getById(String id) {
    try {
      return _chequeDeposits.firstWhere((deposit) => deposit.id == id);
    } catch (e) {
      return null; // Return null if no cheque deposit is found
    }
  }

  @override
  void add(ChequeDeposit deposit) {
    _chequeDeposits.add(deposit);
  }

  @override
  void update(String id, ChequeDeposit updatedDeposit) {
    final index = _chequeDeposits.indexWhere((deposit) => deposit.id == id);
    if (index != -1) {
      _chequeDeposits[index] = updatedDeposit;
    }
  }

  @override
  void delete(String id) {
    _chequeDeposits.removeWhere((deposit) => deposit.id == id);
  }

  // Retrieve all deposits by status
  List<ChequeDeposit> getByStatus(String status) {
    return _chequeDeposits
        .where((deposit) => deposit.status == status)
        .toList();
  }

  // Load initial data from JSON if needed
  Future<void> loadInitialData(List<ChequeDeposit> deposits) async {
    _chequeDeposits.addAll(deposits);
  }
}
