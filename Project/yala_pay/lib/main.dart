import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart'; // Import the app router
import 'providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig:
          AppRouter.router, // Use the configured router from app_router.dart
      title: 'YalaPay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  /* const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Text('Flutter Demo Home Page'),
    );
  } */
}
