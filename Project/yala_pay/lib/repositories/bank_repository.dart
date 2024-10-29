import '../models/bank.dart';
import 'base_repository.dart';

class BankRepository implements BaseRepository<Bank> {
  final List<Bank> _banks = [];

  @override
  List<Bank> getAll() => _banks;

  @override
  Bank? getById(String name) {
    try {
      return _banks.firstWhere((bank) => bank.name == name);
    } catch (e) {
      return null; // Return null if no bank is found
    }
  }

  @override
  void add(Bank bank) {
    _banks.add(bank);
  }

  @override
  void update(String name, Bank updatedBank) {
    final index = _banks.indexWhere((bank) => bank.name == name);
    if (index != -1) _banks[index] = updatedBank;
  }

  @override
  void delete(String name) {
    _banks.removeWhere((bank) => bank.name == name);
  }
}
