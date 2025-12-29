import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:flutter/material.dart';
import '../api/token_manager.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../../main.dart';
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
      host: '10.79.70.236', // Using the same IP as baseUrl
      wsPort: 6001,
      wssPort: 6001,
      encrypted: false,
      cluster: 'mt1',
      auth: PusherAuth(
        'http://10.79.70.236:8000/api/broadcasting/auth',
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
        'New notification received via Echo: $notification',
        name: 'RealtimeNotification',
      );

      try {
        // Handle different possible structures of the notification payload
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          notification,
        );

        // If the payload is wrapped in 'data', unwrap it
        final Map<String, dynamic> finalJson =
            data.containsKey('data') && data['data'] is Map
            ? Map<String, dynamic>.from(data['data'])
            : data;

        // Ensure we have an ID for the model, otherwise generate a temporary one
        if (!finalJson.containsKey('id')) {
          finalJson['id'] = DateTime.now().millisecondsSinceEpoch;
        }

        // Ensure created_at exists
        if (!finalJson.containsKey('created_at')) {
          finalJson['created_at'] = DateTime.now().toIso8601String();
        }

        final notificationModel = NotificationModel.fromJson(finalJson);
        notificationsBloc.add(NewNotificationReceivedEvent(notificationModel));

        // Show a SnackBar notification
        _showNotificationSnackBar(notificationModel);
      } catch (e, stack) {
        dev.log(
          'Error parsing notification: $e',
          name: 'RealtimeNotification',
          error: e,
          stackTrace: stack,
        );
      }
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

  void _showNotificationSnackBar(NotificationModel notification) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    notification.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'عرض',
          textColor: Colors.white,
          onPressed: () {
            // You can add navigation logic here if needed
          },
        ),
      ),
    );
  }

  void _disconnect() {
    dev.log('Disconnecting from Reverb', name: 'RealtimeNotification');
    _echo?.disconnect();
    _pusher?.disconnect();
    _echo = null;
    _pusher = null;
  }
}
