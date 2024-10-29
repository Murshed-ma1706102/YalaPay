import 'package:flutter/material.dart';
import '../repositories/bank_repository.dart';
import '../models/bank.dart';

class BankProvider with ChangeNotifier {
  final BankRepository _bankRepository = BankRepository();

  List<Bank> get banks => _bankRepository.getAll();

  Bank? getBankByName(String name) {
    return _bankRepository.getById(name);
  }

  void addBank(Bank bank) {
    _bankRepository.add(bank);
    notifyListeners();
  }

  void updateBank(String name, Bank updatedBank) {
    _bankRepository.update(name, updatedBank);
    notifyListeners();
  }

  void deleteBank(String name) {
    _bankRepository.delete(name);
    notifyListeners();
  }
}
