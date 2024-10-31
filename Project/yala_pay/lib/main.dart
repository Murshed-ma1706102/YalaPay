import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:yala_pay/providers/cheque_deposit_provider.dart';
import 'package:yala_pay/providers/cheque_provider.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/providers/user_provider.dart';
import 'package:yala_pay/routes/app_router.dart';

void main() {
  runApp(

    const ProviderScope( // for riverPod
      child: MyApp(),
    )
    /*
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ChequeProvider()),
        ChangeNotifierProvider(
            create: (_) => CustomerProvider()..loadCustomers()),
        ChangeNotifierProvider(create: (_) => ChequeProvider()..loadCheques()),
        ChangeNotifierProvider(create: (_) => ChequeDepositProvider()),

        // Standard ChangeNotifierProvider for UserProvider without async initialization
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
      
    )
    */
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
