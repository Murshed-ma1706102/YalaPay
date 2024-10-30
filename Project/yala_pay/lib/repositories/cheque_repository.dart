import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/cheque.dart';
import 'base_repository.dart';

class ChequeRepository implements BaseRepository<Cheque> {
  final List<Cheque> _cheques = [];

  // Synchronous methods as required by BaseRepository
  @override
  List<Cheque> getAll() => _cheques;

  @override
  Cheque? getById(String chequeNo) {
    try {
      return _cheques
          .firstWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
    } catch (e) {
      return null;
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

  // Asynchronous versions of the methods
  Future<List<Cheque>> fetchAllAsync() async {
    if (_cheques.isEmpty) {
      // Load JSON from assets
      final String response =
          await rootBundle.loadString('assets/YalaPay-data/cheques.json');
      final List<dynamic> data = json.decode(response);
      _cheques.addAll(data.map((json) => Cheque.fromJson(json)).toList());
    }
    return _cheques;
  }

  Future<Cheque?> fetchByIdAsync(String chequeNo) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulated async delay
    try {
      return _cheques
          .firstWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
    } catch (e) {
      return null;
    }
  }

  Future<void> addAsync(Cheque cheque) async {
    _cheques.add(cheque);
  }

  Future<void> updateAsync(String chequeNo, Cheque updatedCheque) async {
    final index =
        _cheques.indexWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
    if (index != -1) _cheques[index] = updatedCheque;
  }

  Future<void> deleteAsync(String chequeNo) async {
    _cheques.removeWhere((cheque) => cheque.chequeNo.toString() == chequeNo);
  }
}
