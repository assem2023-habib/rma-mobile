import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import '../api/token_manager.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'dart:developer' as dev;

class RealtimeNotificationService {
  final TokenManager tokenManager;
  final NotificationsBloc notificationsBloc;
  final AuthBloc authBloc;

  Echo? _echo;
  PusherClient? _pusher;

  RealtimeNotificationService({
    required this.tokenManager,
    required this.notificationsBloc,
    required this.authBloc,
  }) {
    _initOnAuthChange();
  }

  void _initOnAuthChange() {
    authBloc.stream.listen((state) {
      if (state is Authenticated) {
        _connect(state.user.id);
      } else if (state is Unauthenticated) {
        _disconnect();
      }
    });
  }

  void _connect(int userId) {
    final token = tokenManager.getToken();
    if (token == null) return;

    dev.log(
      'Connecting to Reverb for user $userId',
      name: 'RealtimeNotification',
    );

    PusherOptions options = PusherOptions(
      host: '10.43.226.236', // Using the same IP as baseUrl
      wsPort: 6001,
      wssPort: 6001,
      encrypted: false,
      cluster: 'mt1',
      auth: PusherAuth(
        'http://10.43.226.236:8000/api/broadcasting/auth',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    _pusher = PusherClient('z8gmvgvmclvhoezjsfil', options, autoConnect: true);

    _echo = Echo(client: _pusher, broadcaster: EchoBroadcasterType.Pusher);

    _echo!.private('App.Models.User.$userId').notification((notification) {
      dev.log(
        'New notification received: $notification',
        name: 'RealtimeNotification',
      );
      final notificationModel = NotificationModel.fromJson(notification);
      notificationsBloc.add(NewNotificationReceivedEvent(notificationModel));
    });

    _pusher!.onConnectionStateChange((state) {
      dev.log(
        'Connection state changed: ${state?.currentState}',
        name: 'RealtimeNotification',
      );
    });

    _pusher!.onConnectionError((error) {
      dev.log(
        'Connection error: ${error?.message}',
        name: 'RealtimeNotification',
      );
    });
  }

  void _disconnect() {
    dev.log('Disconnecting from Reverb', name: 'RealtimeNotification');
    _echo?.disconnect();
    _pusher?.disconnect();
    _echo = null;
    _pusher = null;
  }
}
