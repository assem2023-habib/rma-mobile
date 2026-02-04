import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/app_flavor_config.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/widgets/live_notification_wrapper.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_event.dart';
import 'features/parcels/presentation/bloc/parcels_bloc.dart';
import 'features/parcels/presentation/bloc/parcels_event.dart';
import 'features/routes/presentation/bloc/routes_bloc.dart';
import 'package:rma_customer/features/routes/presentation/bloc/routes_event.dart';
import 'package:rma_customer/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:rma_customer/injection_container.dart' as di;

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => di.sl<DashboardBloc>()..add(const GetDashboardStatsEvent()),
        ),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
        BlocProvider(
          create: (_) => di.sl<ParcelsBloc>()..add(GetParcelsEvent()),
        ),
        BlocProvider(create: (_) => di.sl<RoutesBloc>()..add(GetRoutesEvent())),
        BlocProvider(create: (_) => di.sl<NotificationsBloc>()),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: AppConfig.instance.appTitle,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,

        // RTL Support
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // Force RTL
        builder: (context, child) {
          return LiveNotificationWrapper(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
