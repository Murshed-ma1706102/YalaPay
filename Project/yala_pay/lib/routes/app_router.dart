import 'package:go_router/go_router.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/screens/add_cheque_deposit_screen.dart';
import 'package:yala_pay/screens/add_customer_screen.dart';
import 'package:yala_pay/screens/add_invoice_screen.dart';
import 'package:yala_pay/screens/add_payment_screen.dart';
import 'package:yala_pay/screens/cheque_deposit_details_screen.dart';
import 'package:yala_pay/screens/cheque_filter_screen.dart';
import 'package:yala_pay/screens/customers_screen.dart';
import 'package:yala_pay/screens/edit_cheque_deposit_screen.dart';
import 'package:yala_pay/screens/edit_cheque_screen.dart';
import 'package:yala_pay/screens/invoices_report_screen.dart';
import 'package:yala_pay/screens/update_customer_screen.dart';
import 'package:yala_pay/screens/update_invoice_screen.dart';
import 'package:yala_pay/screens/update_payment_screen.dart';
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
        builder: (context, state) => LoginScreen(),
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
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const InvoicesReportScreen(),
          ),
          GoRoute(
            path: '/chequeFilter',
            name: 'chequeFilter',
            builder: (context, state) => ChequeFilterScreen(),
          ),
          GoRoute(
            path: '/cheques',
            name: 'cheques',
            builder: (context, state) => const ChequesScreen(),
            routes: [
              GoRoute(
                path: '/edit',
                name: 'editCheque',
                builder: (context, state) {
                  final cheque = state.extra as Cheque;
                  return EditChequeScreen(cheque: cheque);
                },
              ),
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
                  GoRoute(
                    path: '/add',
                    name: 'addChequeDeposit',
                    builder: (context, state) => AddChequeDepositScreen(),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
              path: '/invoices',
              name: 'invoices',
              builder: (context, state) => const InvoicesScreen(),
              routes: [
                GoRoute(
                  path: 'addInvoice',
                  name: 'addInvoice',
                  builder: (context, state) => AddInvoiceScreen(),
                ),
                GoRoute(
                  path: '/invoices/updateInvoice/:invoiceId',
                  name: 'updateInvoice',
                  builder: (context, state) {
                    final invoiceId = state.pathParameters['invoiceId']!;
                    return UpdateInvoiceScreen(invoiceId: invoiceId);
                  },
                ),
                GoRoute(
                    name: 'payments',
                    path: '/payments/:invoiceId',
                    builder: (context, state) {
                      final invoiceId = state.pathParameters['invoiceId']!;
                      return PaymentsScreen(invoiceId: invoiceId);
                    },
                    routes: [
                      GoRoute(
                        name: 'addPayment',
                        path: '/addPayment',
                        builder: (context, state) {
                          final invoiceId = state.pathParameters['invoiceId']!;
                          return AddPaymentScreen(invoiceId: invoiceId);
                        },
                      ),
                      GoRoute(
                        name: 'updatePayment',
                        path: '/updatePayment/:paymentId',
                        builder: (context, state) {
                          final invoiceId = state.pathParameters['invoiceId']!;
                          final paymentId = state.pathParameters['paymentId']!;
                          return UpdatePaymentScreen(
                              invoiceId: invoiceId, paymentId: paymentId);
                        },
                      ),
                    ]),
              ]),
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
              GoRoute(
                  path: '/customer/updateCustomer/:customerId',
                  name: 'updateCustomer',
                  builder: (context, state) {
                    final customerId = state.pathParameters['customerId']!;
                    return UpdateCustomerScreen(customerId: customerId);
                  }),
            ],
          ),
        ],
      ),
    ],
  );
}
