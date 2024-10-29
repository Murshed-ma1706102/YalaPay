import 'package:flutter/material.dart';
import '../repositories/bank_account_repository.dart';
import '../models/bank_account.dart';

class BankAccountProvider with ChangeNotifier {
  final BankAccountRepository _bankAccountRepository = BankAccountRepository();

  List<BankAccount> get bankAccounts => _bankAccountRepository.getAll();

  BankAccount? getBankAccountByNo(String accountNo) {
    return _bankAccountRepository.getById(accountNo);
  }

  void addBankAccount(BankAccount account) {
    _bankAccountRepository.add(account);
    notifyListeners();
  }

  void updateBankAccount(String accountNo, BankAccount updatedAccount) {
    _bankAccountRepository.update(accountNo, updatedAccount);
    notifyListeners();
  }

  void deleteBankAccount(String accountNo) {
    _bankAccountRepository.delete(accountNo);
    notifyListeners();
  }
}
