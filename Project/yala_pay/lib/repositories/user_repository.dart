import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user.dart';
import 'base_repository.dart';

class UserRepository implements BaseRepository<User> {
  final List<User> _users = [];

  UserRepository();

  Future<void> loadUsers() async {
    await _loadUsersFromJson();
    print(
        "Users loaded: ${_users.map((user) => user.email).toList()}"); // Debug print
  }

  Future<void> _loadUsersFromJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/YalaPay-data/users.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _users.addAll(jsonData.map((userJson) => User.fromJson(userJson)));
      print(
          "Loaded users: ${_users.map((user) => user.email).toList()}"); // Debugging output
    } catch (e) {
      print("Error loading users.json: $e");
    }
  }

  @override
  List<User> getAll() => _users;

  @override
  User? getById(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  void add(User user) => _users.add(user);

  @override
  void update(String email, User updatedUser) {
    final index = _users.indexWhere((user) => user.email == email);
    if (index != -1) _users[index] = updatedUser;
  }

  @override
  void delete(String email) =>
      _users.removeWhere((user) => user.email == email);
}
