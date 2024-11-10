import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankListProvider = FutureProvider<List<String>>((ref) async {
  try {
    final String response = await rootBundle.loadString('assets/YalaPay-data/banks.json');
    final List<dynamic> data = json.decode(response);
    return List<String>.from(data);
  } catch (e) {
    print('Error loading bank data: $e');
    return [];
  }
});
