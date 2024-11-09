import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentModeProvider = StateProvider<String>((ref) {
  return "cheque"; // Default payment mode
});
