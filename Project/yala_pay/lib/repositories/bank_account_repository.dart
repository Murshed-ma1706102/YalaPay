import '../models/bank_account.dart';
import 'base_repository.dart';

class BankAccountRepository implements BaseRepository<BankAccount> {
  final List<BankAccount> _bankAccounts = [];

  @override
  List<BankAccount> getAll() => _bankAccounts;

  @override
  BankAccount? getById(String accountNo) {
    try {
      return _bankAccounts
          .firstWhere((account) => account.accountNo == accountNo);
    } catch (e) {
      return null; // Return null if no bank account is found
    }
  }

  @override
  void add(BankAccount account) {
    _bankAccounts.add(account);
  }

  @override
  void update(String accountNo, BankAccount updatedAccount) {
    final index =
        _bankAccounts.indexWhere((account) => account.accountNo == accountNo);
    if (index != -1) _bankAccounts[index] = updatedAccount;
  }

  @override
  void delete(String accountNo) {
    _bankAccounts.removeWhere((account) => account.accountNo == accountNo);
  }
}
