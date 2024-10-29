import '../models/cheque.dart';
import 'base_repository.dart';

class ChequeRepository implements BaseRepository<Cheque> {
  final List<Cheque> _cheques = [];

  @override
  List<Cheque> getAll() => _cheques;

  @override
  Cheque? getById(String chequeNo) {
    try {
      return _cheques
          .firstWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
    } catch (e) {
      return null; // Return null if no cheque is found
    }
  }

  @override
  void add(Cheque cheque) {
    _cheques.add(cheque);
  }

  @override
  void update(String chequeNo, Cheque updatedCheque) {
    final index =
        _cheques.indexWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
    if (index != -1) _cheques[index] = updatedCheque;
  }

  @override
  void delete(String chequeNo) {
    _cheques.removeWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
  }
}
