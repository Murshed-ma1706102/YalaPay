// user_repository.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UserRepository {
  final List<User> _users = [];

  UserRepository();

  Future<void> loadUsers() async {
    if (_users.isEmpty) {
      await _loadUsersFromJson();
    }
  }

  Future<void> _loadUsersFromJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/YalaPay-data/users.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _users.addAll(jsonData.map((userJson) => User.fromJson(userJson)));
    } catch (e) {
      print("Error loading users.json: $e");
    }
  }

  List<User> getAll() => _users;

  User? getById(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  void add(User user) => _users.add(user);

  void update(String email, User updatedUser) {
    final index = _users.indexWhere((user) => user.email == email);
    if (index != -1) _users[index] = updatedUser;
  }

  void delete(String email) =>
      _users.removeWhere((user) => user.email == email);
}

// Define userRepositoryProvider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
