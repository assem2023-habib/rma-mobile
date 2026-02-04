import 'package:go_router/go_router.dart';
import 'package:rma_customer/features/appointments/presentation/pages/admin_appointments_page.dart';
import 'package:rma_customer/features/auth/presentation/pages/login_page.dart';
import 'package:rma_customer/features/auth/presentation/pages/register_page.dart';
import 'package:rma_customer/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:rma_customer/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:rma_customer/features/auth/presentation/pages/reset_password_page.dart';
import 'package:rma_customer/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:rma_customer/features/dashboard/presentation/pages/admin_placeholder_page.dart';
import 'package:rma_customer/features/parcels/presentation/pages/admin_parcels_page.dart';
import 'package:rma_customer/features/parcels/presentation/pages/parcels_page.dart';
import 'package:rma_customer/features/parcels/presentation/pages/new_parcel_page.dart';
import 'package:rma_customer/features/parcels/presentation/pages/parcel_detail_page.dart';
import 'package:rma_customer/features/routes/presentation/pages/routes_page.dart';
import 'package:rma_customer/features/routes/presentation/pages/route_detail_page.dart';
import 'package:rma_customer/features/parcels/domain/entities/parcel.dart';
import 'package:rma_customer/features/routes/domain/entities/route_entity.dart';
import 'package:rma_customer/features/authorizations/presentation/pages/authorizations_page.dart';
import 'package:rma_customer/features/authorizations/presentation/pages/request_authorization_page.dart';
import 'package:rma_customer/features/authorizations/presentation/bloc/authorizations_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rma_customer/injection_container.dart';
import 'package:rma_customer/features/map/presentation/bloc/map_bloc.dart';
import 'package:rma_customer/features/map/presentation/pages/map_page.dart';
import 'package:rma_customer/features/profile/presentation/pages/profile_page.dart';
import 'package:rma_customer/features/notifications/presentation/pages/notification_screen.dart';
import 'package:rma_customer/features/chat/presentation/pages/chat_list_page.dart';
import 'package:rma_customer/features/chat/presentation/pages/chat_detail_page.dart';

import 'package:rma_customer/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:rma_customer/features/onboarding/presentation/pages/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return VerifyOtpPage(
            email: data['email'] as String,
            isTelegram: data['isTelegram'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return ResetPasswordPage(
            email: data['email'] as String,
            otp: data['otp'] as String,
          );
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardHomePage(),
      ),
      // Admin Routes
      GoRoute(
        path: '/admin/parcels',
        builder: (context, state) => const AdminParcelsPage(),
      ),
      GoRoute(
        path: '/admin/appointments',
        builder: (context, state) => const AdminAppointmentsPage(),
      ),
      GoRoute(
        path: '/admin/shipments',
        builder: (context, state) =>
            const AdminPlaceholderPage(title: 'إدارة الشحنات'),
      ),
      // Super Admin Routes
      GoRoute(
        path: '/super-admin/branches',
        builder: (context, state) =>
            const AdminPlaceholderPage(title: 'إدارة الفروع'),
      ),
      GoRoute(
        path: '/super-admin/employees',
        builder: (context, state) =>
            const AdminPlaceholderPage(title: 'إدارة الموظفين'),
      ),
      GoRoute(
        path: '/parcels',
        builder: (context, state) => const ParcelsPage(),
      ),
      GoRoute(
        path: '/new-parcel',
        builder: (context, state) => const NewParcelPage(),
      ),
      GoRoute(
        path: '/parcels/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final parcel = state.extra as Parcel?;
          return ParcelDetailPage(parcelId: id, parcel: parcel);
        },
      ),
      GoRoute(path: '/routes', builder: (context, state) => const RoutesPage()),
      GoRoute(
        path: '/route-detail',
        builder: (context, state) {
          final route = state.extra as RouteEntity;
          return RouteDetailPage(route: route);
        },
      ),
      GoRoute(
        path: '/authorizations',
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthorizationsBloc>(),
          child: const AuthorizationsPage(),
        ),
      ),
      GoRoute(
        path: '/request-authorization',
        builder: (context, state) {
          final parcelId = state.extra as int?;
          return BlocProvider(
            create: (context) => sl<AuthorizationsBloc>(),
            child: RequestAuthorizationPage(parcelId: parcelId),
          );
        },
      ),
      GoRoute(
        path: '/map/:parcelId',
        builder: (context, state) {
          final parcelId = state.pathParameters['parcelId'] ?? '';
          return BlocProvider(
            create: (context) => sl<MapBloc>(),
            child: MapPage(parcelId: parcelId),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(path: '/chat', builder: (context, state) => const ChatListPage()),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final subject = state.extra as String? ?? 'المحادثة';
          return ChatDetailPage(conversationId: id, subject: subject);
        },
      ),
    ],
  );
}
