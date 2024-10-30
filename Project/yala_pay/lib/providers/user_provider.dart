import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  bool isLoading = true;
  User? _currentUser;

  UserProvider() {
    _initializeUsers();
    _loadUserSession(); // Attempt to load user session if one exists
  }

  List<User> get users => _userRepository.getAll();
  User? get currentUser => _currentUser;

  // Initialize users by loading from repository
  Future<void> _initializeUsers() async {
    await _userRepository.loadUsers();
    isLoading = false;
    notifyListeners();
  }

  // Load saved user session if it exists
  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email != null) {
      _currentUser = _userRepository.getById(email);
    }
    isLoading = false;
    notifyListeners();
  }

  // Log in a user by email and password
  User? login(String email, String password) {
    final user = _userRepository.getById(email);
    if (user != null && user.password == password) {
      _currentUser = user;
      _saveUserSession(user); // Save session on successful login
      notifyListeners();
      return user;
    }
    return null;
  }

  // Log out the user and clear session
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  // Get user by email without logging them in
  User? getUserByEmail(String email) {
    return _userRepository.getById(email);
  }

  // Save user session to local storage
  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', user.email);
  }
}
