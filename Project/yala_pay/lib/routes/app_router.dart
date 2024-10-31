import 'package:go_router/go_router.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/screens/add_customer_screen.dart';
import 'package:yala_pay/screens/cheque_deposit_details_screen.dart';
import 'package:yala_pay/screens/customers_screen.dart';
import 'package:yala_pay/screens/edit_cheque_deposit_screen';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/payments_screen.dart';
import '../screens/cheques_screen.dart';
import '../screens/invoices_screen.dart';
import '../screens/cheque_deposits_screen.dart';
//import '../screens/cheque_deposit_details.dart';
import '../widgets/bottom_navigation_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/payments',
            name: 'payments',
            builder: (context, state) => const PaymentsScreen(),
          ),
          GoRoute(
            path: '/cheques',
            name: 'cheques',
            builder: (context, state) => ChequesScreen(),
            routes: [
              GoRoute(
                path: '/deposits',
                name: 'chequeDeposits',
                builder: (context, state) => ChequeDepositsScreen(),
                routes: [
                  GoRoute(
                    path: '/details',
                    name: 'chequeDepositDetails',
                    builder: (context, state) {
                      final ChequeDeposit deposit =
                          state.extra as ChequeDeposit;
                      return ChequeDepositDetails(deposit: deposit);
                    },
                  ),
                  GoRoute(
                    path: '/edit',
                    name: 'editChequeDeposit',
                    builder: (context, state) {
                      final ChequeDeposit deposit =
                          state.extra as ChequeDeposit;
                      return EditChequeDepositScreen(deposit: deposit);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/invoices',
            name: 'invoices',
            builder: (context, state) => const InvoicesScreen(),
          ),
          GoRoute(
            path: '/customer',
            name: 'customer',
            builder: (context, state) => const CustomersScreen(),
            routes: [
              GoRoute(
                path: 'addCustomer',
                name: 'addCustomer',
                builder: (context, state) => AddCustomerScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
