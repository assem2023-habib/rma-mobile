import 'package:go_router/go_router.dart';
import 'package:rma_customer/features/auth/presentation/pages/login_page.dart';
import 'package:rma_customer/features/auth/presentation/pages/register_page.dart';
import 'package:rma_customer/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:rma_customer/features/parcels/presentation/pages/parcels_page.dart';
import 'package:rma_customer/features/parcels/presentation/pages/new_parcel_page.dart';
import 'package:rma_customer/features/routes/presentation/pages/routes_page.dart';
import 'package:rma_customer/features/authorizations/presentation/pages/authorizations_page.dart';
import 'package:rma_customer/features/authorizations/presentation/pages/request_authorization_page.dart';
import 'package:rma_customer/features/map/presentation/pages/map_page.dart';
import 'package:rma_customer/features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardHomePage(),
      ),
      GoRoute(
        path: '/parcels',
        builder: (context, state) => const ParcelsPage(),
      ),
      GoRoute(
        path: '/new-parcel',
        builder: (context, state) => const NewParcelPage(),
      ),
      GoRoute(path: '/routes', builder: (context, state) => const RoutesPage()),
      GoRoute(
        path: '/authorizations',
        builder: (context, state) => const AuthorizationsPage(),
      ),
      GoRoute(
        path: '/request-authorization',
        builder: (context, state) => const RequestAuthorizationPage(),
      ),
      GoRoute(
        path: '/map/:parcelId',
        builder: (context, state) {
          final parcelId = state.pathParameters['parcelId'] ?? '';
          return MapPage(parcelId: parcelId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
