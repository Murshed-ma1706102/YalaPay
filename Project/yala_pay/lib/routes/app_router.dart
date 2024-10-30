import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/payments_screen.dart';
import '../screens/cheques_screen.dart';
import '../screens/invoices_screen.dart';
import '../widgets/bottom_navigation_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavigationShell(
              child: child); // Persistent navigation shell
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) {
              return const DashboardScreen();
            },
          ),
          GoRoute(
            path: '/payments',
            name: 'payments',
            builder: (context, state) => const PaymentsScreen(),
          ),
          GoRoute(
            path: '/cheques',
            name: 'cheques',
            builder: (context, state) => const ChequesScreen(),
          ),
          GoRoute(
            path: '/invoices',
            name: 'invoices',
            builder: (context, state) => const InvoicesScreen(),
          ),
        ],
      ),
    ],
  );
}
