// user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/user_repository.dart';
import '../models/user.dart';

class UserProvider extends StateNotifier<User?> {
  final UserRepository _userRepository;
  bool isLoading = false;
  String? errorMessage;

  UserProvider(this._userRepository) : super(null) {
    _initializeUsers();
    _loadUserSession();
  }

  Future<void> _initializeUsers() async {
    isLoading = true;
    state = state; // Trigger rebuild

    await _userRepository.loadUsers();
    isLoading = false;
    state = state; // Trigger rebuild
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');

    if (email != null) {
      final user = _userRepository.getById(email);
      if (user != null) {
        state = user;
      }
    }
    isLoading = false;
    state = state; // Trigger rebuild
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    state = state; // Trigger rebuild

    final user = _userRepository.getById(email);
    if (user != null && user.password == password) {
      await _saveUserSession(user);
      state = user;
    } else {
      errorMessage = 'Invalid email or password';
    }

    isLoading = false;
    state = state; // Trigger rebuild
  }

  Future<void> logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    errorMessage = null;
    isLoading = false;
    state = state; // Trigger rebuild
  }

  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', user.email);
  }
}

// Define userProvider with dependency on userRepositoryProvider
final userProvider = StateNotifierProvider<UserProvider, User?>(
  (ref) => UserProvider(ref.read(userRepositoryProvider)),
);
