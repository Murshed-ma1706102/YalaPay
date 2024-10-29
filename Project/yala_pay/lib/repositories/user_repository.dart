import '../models/user.dart';
import 'base_repository.dart';

class UserRepository implements BaseRepository<User> {
  final List<User> _users = [];

  @override
  List<User> getAll() => _users;

  @override
  User? getById(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null; // Return null if no user is found
    }
  }

  @override
  void add(User user) {
    _users.add(user);
  }

  @override
  void update(String email, User updatedUser) {
    final index = _users.indexWhere((user) => user.email == email);
    if (index != -1) _users[index] = updatedUser;
  }

  @override
  void delete(String email) {
    _users.removeWhere((user) => user.email == email);
  }
}
