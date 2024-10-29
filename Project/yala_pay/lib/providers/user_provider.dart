import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  bool isLoading = true;

  UserProvider() {
    _initializeUsers();
  }

  // Initialize users by loading from repository
  Future<void> _initializeUsers() async {
    await _userRepository.loadUsers();
    isLoading = false;
    notifyListeners();
  }

  List<User> get users => _userRepository.getAll();

  User? getUserByEmail(String email) {
    return _userRepository.getById(email);
  }
}
