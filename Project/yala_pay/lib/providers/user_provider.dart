import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  List<User> get users => _userRepository.getAll();

  User? getUserByEmail(String email) {
    return _userRepository.getById(email);
  }

  void addUser(User user) {
    _userRepository.add(user);
    notifyListeners();
  }

  void updateUser(String email, User updatedUser) {
    _userRepository.update(email, updatedUser);
    notifyListeners();
  }

  void deleteUser(String email) {
    _userRepository.delete(email);
    notifyListeners();
  }
}
