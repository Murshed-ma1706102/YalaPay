import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yala_pay/providers/cheque_provider.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/providers/user_provider.dart';
import 'package:yala_pay/routes/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ChequeProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),

        // Standard ChangeNotifierProvider for UserProvider without async initialization
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'YalaPay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
