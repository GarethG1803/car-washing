import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:clean_ride/data/models/user.dart';

// Auth screens
import 'package:clean_ride/features/auth/screens/welcome_screen.dart';
import 'package:clean_ride/features/auth/screens/login_screen.dart';
import 'package:clean_ride/features/auth/screens/register_screen.dart';
import 'package:clean_ride/features/auth/screens/role_select_screen.dart';

// Customer shell
import 'package:clean_ride/features/customer/shell/customer_shell.dart';

// Customer screens
import 'package:clean_ride/features/customer/home/screens/customer_home_screen.dart';
import 'package:clean_ride/features/customer/services/screens/service_catalog_screen.dart';
import 'package:clean_ride/features/customer/services/screens/service_detail_screen.dart';
import 'package:clean_ride/features/customer/orders/screens/order_history_screen.dart';
import 'package:clean_ride/features/customer/orders/screens/order_detail_screen.dart';
import 'package:clean_ride/features/customer/profile/screens/customer_profile_screen.dart';
import 'package:clean_ride/features/customer/booking/screens/booking_flow_screen.dart';
import 'package:clean_ride/features/customer/booking/screens/booking_confirmed_screen.dart';
import 'package:clean_ride/features/customer/tracking/screens/tracking_screen.dart';
import 'package:clean_ride/features/customer/payments/screens/payment_methods_screen.dart';
import 'package:clean_ride/features/customer/payments/screens/wallet_screen.dart';
import 'package:clean_ride/features/customer/profile/screens/vehicle_management_screen.dart';
import 'package:clean_ride/features/customer/profile/screens/add_vehicle_screen.dart';
import 'package:clean_ride/features/customer/profile/screens/edit_profile_screen.dart';
import 'package:clean_ride/features/customer/loyalty/screens/loyalty_screen.dart';
import 'package:clean_ride/features/customer/loyalty/screens/referral_screen.dart';
import 'package:clean_ride/features/customer/notifications/screens/notifications_screen.dart';
import 'package:clean_ride/features/customer/reviews/screens/rate_service_screen.dart';

// Washer shell
import 'package:clean_ride/features/washer/shell/washer_shell.dart';

// Washer screens
import 'package:clean_ride/features/washer/dashboard/screens/washer_dashboard_screen.dart';
import 'package:clean_ride/features/washer/jobs/screens/job_queue_screen.dart';
import 'package:clean_ride/features/washer/jobs/screens/job_detail_screen.dart';
import 'package:clean_ride/features/washer/earnings/screens/earnings_screen.dart';
import 'package:clean_ride/features/washer/schedule/screens/schedule_screen.dart';
import 'package:clean_ride/features/washer/profile/screens/washer_profile_screen.dart';

// Admin shell
import 'package:clean_ride/features/admin/shell/admin_shell.dart';

// Admin screens
import 'package:clean_ride/features/admin/dashboard/screens/admin_dashboard_screen.dart';
import 'package:clean_ride/features/admin/bookings/screens/admin_bookings_screen.dart';
import 'package:clean_ride/features/admin/bookings/screens/admin_booking_detail.dart';
import 'package:clean_ride/features/admin/employees/screens/employee_list_screen.dart';
import 'package:clean_ride/features/admin/employees/screens/employee_detail_screen.dart';
import 'package:clean_ride/features/admin/finance/screens/finance_overview_screen.dart';
import 'package:clean_ride/features/admin/finance/screens/invoice_screen.dart';
import 'package:clean_ride/features/admin/settings/screens/admin_settings_screen.dart';
import 'package:clean_ride/features/admin/customers/screens/customer_crm_screen.dart';
import 'package:clean_ride/features/admin/customers/screens/customer_crm_detail.dart';
import 'package:clean_ride/features/admin/employees/screens/payroll_screen.dart';
import 'package:clean_ride/features/admin/services/screens/service_management_screen.dart';
import 'package:clean_ride/features/admin/analytics/screens/analytics_screen.dart';
import 'package:clean_ride/features/admin/promotions/screens/promotions_screen.dart';

/// Tracks the currently selected user role.
final roleProvider = StateProvider<UserRole?>((ref) => null);

/// Provides the app-wide GoRouter instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // ── Auth routes ──────────────────────────────────────────────────
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/role-select',
        builder: (context, state) => const RoleSelectScreen(),
      ),

      // ── Customer shell ───────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CustomerShell(child: navigationShell),
        branches: [
          // Branch 0 – Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customer/home',
                builder: (context, state) => const CustomerHomeScreen(),
              ),
            ],
          ),
          // Branch 1 – Services
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customer/services',
                builder: (context, state) => const ServiceCatalogScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ServiceDetailScreen(
                      serviceId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2 – Bookings / Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customer/bookings',
                builder: (context, state) => const OrderHistoryScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => OrderDetailScreen(
                      bookingId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 3 – Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customer/profile',
                builder: (context, state) => const CustomerProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Customer non-shell routes ────────────────────────────────────
      GoRoute(
        path: '/customer/booking/flow',
        builder: (context, state) => const BookingFlowScreen(),
      ),
      GoRoute(
        path: '/customer/booking/confirmed',
        builder: (context, state) => const BookingConfirmedScreen(),
      ),
      GoRoute(
        path: '/customer/tracking/:id',
        builder: (context, state) => TrackingScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/customer/payments',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/customer/payments/wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/customer/profile/vehicles',
        builder: (context, state) => const VehicleManagementScreen(),
      ),
      GoRoute(
        path: '/customer/profile/vehicles/add',
        builder: (context, state) => const AddVehicleScreen(),
      ),
      GoRoute(
        path: '/customer/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/customer/loyalty',
        builder: (context, state) => const LoyaltyScreen(),
      ),
      GoRoute(
        path: '/customer/loyalty/referral',
        builder: (context, state) => const ReferralScreen(),
      ),
      GoRoute(
        path: '/customer/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/customer/rate/:bookingId',
        builder: (context, state) => RateServiceScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),

      // ── Washer shell ─────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            WasherShell(child: navigationShell),
        branches: [
          // Branch 0 – Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/washer/dashboard',
                builder: (context, state) => const WasherDashboardScreen(),
              ),
            ],
          ),
          // Branch 1 – Jobs
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/washer/jobs',
                builder: (context, state) => const JobQueueScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => JobDetailScreen(
                      jobId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2 – Earnings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/washer/earnings',
                builder: (context, state) => const EarningsScreen(),
              ),
            ],
          ),
          // Branch 3 – Schedule
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/washer/schedule',
                builder: (context, state) => const ScheduleScreen(),
              ),
            ],
          ),
          // Branch 4 – Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/washer/profile',
                builder: (context, state) => const WasherProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Admin shell ──────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminShell(child: navigationShell),
        branches: [
          // Branch 0 – Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/dashboard',
                builder: (context, state) => const AdminDashboardScreen(),
              ),
            ],
          ),
          // Branch 1 – Bookings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/bookings',
                builder: (context, state) => const AdminBookingsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => AdminBookingDetail(
                      bookingId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2 – Team
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/team',
                builder: (context, state) => const EmployeeListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => EmployeeDetailScreen(
                      employeeId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 3 – Finance
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/finance',
                builder: (context, state) => const FinanceOverviewScreen(),
                routes: [
                  GoRoute(
                    path: 'invoices',
                    builder: (context, state) => const InvoiceScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 4 – More / Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/more',
                builder: (context, state) => const AdminSettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Admin non-shell routes ───────────────────────────────────────
      GoRoute(
        path: '/admin/customers',
        builder: (context, state) => const CustomerCrmScreen(),
      ),
      GoRoute(
        path: '/admin/customers/:id',
        builder: (context, state) => CustomerCrmDetail(
          customerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/admin/team/payroll',
        builder: (context, state) => const PayrollScreen(),
      ),
      GoRoute(
        path: '/admin/services-mgmt',
        builder: (context, state) => const ServiceManagementScreen(),
      ),
      GoRoute(
        path: '/admin/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/admin/promotions',
        builder: (context, state) => const PromotionsScreen(),
      ),
    ],
  );
});
