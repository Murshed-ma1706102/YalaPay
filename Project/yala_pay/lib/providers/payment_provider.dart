import 'package:flutter/material.dart';
import '../repositories/payment_repository.dart';
import '../models/payment.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository = PaymentRepository();

  List<Payment> get payments => _paymentRepository.getAll();

  Payment? getPaymentById(String id) {
    return _paymentRepository.getById(id);
  }

  void addPayment(Payment payment) {
    _paymentRepository.add(payment);
    notifyListeners();
  }

  void updatePayment(String id, Payment updatedPayment) {
    _paymentRepository.update(id, updatedPayment);
    notifyListeners();
  }

  void deletePayment(String id) {
    _paymentRepository.delete(id);
    notifyListeners();
  }
}
