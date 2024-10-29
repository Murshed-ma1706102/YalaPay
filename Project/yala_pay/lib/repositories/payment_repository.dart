import '../models/payment.dart';
import 'base_repository.dart';

class PaymentRepository implements BaseRepository<Payment> {
  final List<Payment> _payments = [];

  @override
  List<Payment> getAll() => _payments;

  @override
  Payment? getById(String id) {
    try {
      return _payments.firstWhere((payment) => payment.id == id);
    } catch (e) {
      return null; // Return null if no payment is found
    }
  }

  @override
  void add(Payment payment) {
    _payments.add(payment);
  }

  @override
  void update(String id, Payment updatedPayment) {
    final index = _payments.indexWhere((payment) => payment.id == id);
    if (index != -1) _payments[index] = updatedPayment;
  }

  @override
  void delete(String id) {
    _payments.removeWhere((payment) => payment.id == id);
  }
}
