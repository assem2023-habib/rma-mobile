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
    // Check initial state in case the user is already authenticated
    final currentState = authBloc.state;
    if (currentState is Authenticated) {
      dev.log(
        'User already authenticated on service init, connecting...',
        name: 'RealtimeNotification',
      );
      _connect(currentState.user.id);
    }

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
      host: '10.43.226.236',
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

    _pusher!.onConnectionError((error) {
      dev.log(
        'CONNECTION ERROR: ${error?.message}',
        name: 'RealtimeNotification',
        error: error?.exception,
      );
    });

    _echo = Echo(
      client: _pusher,
      broadcaster: EchoBroadcasterType.Pusher,
      options: {
        'host': 'http://10.43.226.236:6001',
        'authEndpoint': 'http://10.43.226.236:8000/api/broadcasting/auth',
        'auth': {
          'headers': {'Authorization': 'Bearer $token'},
        },
      },
    );

    final channelName = 'App.Models.User.$userId';
    dev.log(
      'Subscribing to private channel: $channelName',
      name: 'RealtimeNotification',
    );

    final channel = _echo!.private(channelName);

    channel.notification((notification) {
      dev.log(
        'NOTIFICATION RECEIVED via .notification()! Payload: $notification',
        name: 'RealtimeNotification',
      );
      _handleNotification(notification);
    });

    // Listen for the event with and without the leading dot
    // Laravel Echo usually expects a dot for full namespaces
    const eventName =
        'Illuminate\\Notifications\\Events\\BroadcastNotificationCreated';

    channel.listen('.$eventName', (event) {
      dev.log(
        'EVENT RECEIVED via .listen(.$eventName)! Payload: $event',
        name: 'RealtimeNotification',
      );
      _handleNotification(event);
    });

    channel.listen(eventName, (event) {
      dev.log(
        'EVENT RECEIVED via .listen($eventName)! Payload: $event',
        name: 'RealtimeNotification',
      );
      _handleNotification(event);
    });

    // Cleanup the duplicate connection state listener
    _pusher!.onConnectionStateChange((state) {
      dev.log(
        'Connection state changed: from ${state?.previousState} to ${state?.currentState}',
        name: 'RealtimeNotification',
      );
      if (state?.currentState == 'CONNECTED') {
        dev.log('SUCCESS: Connected to Reverb!', name: 'RealtimeNotification');
      }
    });
  }

  void _handleNotification(dynamic notification) {
    try {
      final Map<String, dynamic> rawData = Map<String, dynamic>.from(
        notification,
      );

      dev.log(
        'Processing notification payload...',
        name: 'RealtimeNotification',
      );

      // Laravel BroadcastNotificationCreated usually has a 'data' field
      // but also top-level 'id' and 'type'.
      final Map<String, dynamic> finalJson = {};

      // Start with the raw data
      finalJson.addAll(rawData);

      // If there's a nested 'data' field, merge its contents into the top level
      // so NotificationModel.fromJson can find fields like 'title' and 'message'
      if (rawData.containsKey('data') && rawData['data'] is Map) {
        final nestedData = Map<String, dynamic>.from(rawData['data']);
        finalJson.addAll(nestedData);
      }

      // Ensure we have an ID for the model
      if (finalJson['id'] == null) {
        finalJson['id'] = DateTime.now().millisecondsSinceEpoch;
      }

      // Ensure created_at exists
      if (finalJson['created_at'] == null) {
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
