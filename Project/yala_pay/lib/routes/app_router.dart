import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => DashboardScreen(),
      ),
    ],
  );
}
