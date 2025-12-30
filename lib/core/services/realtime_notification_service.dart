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
      print(
        '🛰️ [RealtimeNotificationService] User authenticated on init, connecting...',
      );
      _connect(currentState.user.id);
    }

    authBloc.stream.listen((state) {
      if (state is Authenticated) {
        print(
          '🛰️ [RealtimeNotificationService] User authenticated via stream, connecting...',
        );
        _connect(state.user.id);
      } else if (state is Unauthenticated) {
        print(
          '🛰️ [RealtimeNotificationService] User logged out, disconnecting...',
        );
        _disconnect();
      }
    });
  }

  void _connect(int userId) {
    final token = tokenManager.getToken();
    if (token == null) {
      print('❌ [RealtimeNotificationService] FAILED to connect: Token is null');
      return;
    }

    print(
      '🛰️ [RealtimeNotificationService] INITIALIZING connection to Reverb for user $userId',
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
      print(
        '🔴 [RealtimeNotificationService] CONNECTION ERROR: ${error?.message}',
      );
      if (error?.exception != null)
        print(
          '🔴 [RealtimeNotificationService] Exception: ${error?.exception}',
        );
    });

    _pusher!.onConnectionStateChange((state) {
      print(
        '🔵 [RealtimeNotificationService] State: ${state?.previousState} -> ${state?.currentState}',
      );
      if (state?.currentState == 'CONNECTED') {
        print(
          '✅ [RealtimeNotificationService] SUCCESS: Socket connected to Reverb server!',
        );
      }
    });

    _echo = Echo(
      client: _pusher,
      broadcaster: EchoBroadcasterType.Pusher,
      options: {
        'host': '10.43.226.236', // Removed http:// and port for host option
        'wsPort': 6001,
        'wssPort': 6001,
        'encrypted': false,
        'authEndpoint': 'http://10.43.226.236:8000/api/broadcasting/auth',
        'auth': {
          'headers': {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        },
      },
    );

    final channelName = 'App.Models.User.$userId';
    print(
      '🛰️ [RealtimeNotificationService] Subscribing to private channel: $channelName',
    );

    final channel = _echo!.private(channelName);

    // Track subscription success/error
    _pusher!.onEvent((event) {
      print(
        '📡 [RealtimeNotificationService] PUSHER EVENT: ${event?.eventName} on ${event?.channelName}',
      );
      if (event?.eventName == 'pusher:subscription_succeeded') {
        print(
          '✅ [RealtimeNotificationService] SUBSCRIPTION SUCCESSFUL to $channelName',
        );
      } else if (event?.eventName == 'pusher:subscription_error') {
        print(
          '❌ [RealtimeNotificationService] SUBSCRIPTION FAILED to $channelName',
        );
      }
    });

    _pusher!.subscribe(channelName); // Ensure subscription is triggered

    channel.notification((notification) {
      print(
        '📥 [RealtimeNotificationService] NOTIFICATION RECEIVED via .notification()!',
      );
      _handleNotification(notification);
    });

    const eventName =
        'Illuminate\\Notifications\\Events\\BroadcastNotificationCreated';

    channel.listen('.$eventName', (event) {
      print(
        '📥 [RealtimeNotificationService] EVENT RECEIVED via .listen(.$eventName)!',
      );
      _handleNotification(event);
    });

    channel.listen(eventName, (event) {
      print(
        '📥 [RealtimeNotificationService] EVENT RECEIVED via .listen($eventName)!',
      );
      _handleNotification(event);
    });
  }

  /// Trigger a test notification to verify UI and logs
  void triggerTestNotification() {
    print('🧪 [RealtimeNotificationService] Triggering Test Notification...');
    final testPayload = {
      'id': 'test-uuid-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'test_notification',
      'title': 'إشعار تجريبي 🧪',
      'message': 'هذا إشعار وهمي لاختبار الاتصال والواجهة.',
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
      'data': {'test_key': 'test_value'},
    };
    print('🧪 [RealtimeNotificationService] Test Payload: $testPayload');
    _handleNotification(testPayload);
  }

  void _handleNotification(dynamic notification) {
    try {
      print(
        '📥 [RealtimeNotificationService] Handling incoming notification...',
      );
      print('📥 [RealtimeNotificationService] Raw Payload: $notification');

      final Map<String, dynamic> rawData = Map<String, dynamic>.from(
        notification,
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
        finalJson['id'] = 'temp-${DateTime.now().millisecondsSinceEpoch}';
      }

      // Ensure created_at exists
      if (finalJson['created_at'] == null) {
        finalJson['created_at'] = DateTime.now().toIso8601String();
      }

      print('📥 [RealtimeNotificationService] Final Parsed JSON: $finalJson');

      final notificationModel = NotificationModel.fromJson(finalJson);
      print(
        '📥 [RealtimeNotificationService] Created Model: ${notificationModel.id}',
      );

      notificationsBloc.add(NewNotificationReceivedEvent(notificationModel));
      print('📥 [RealtimeNotificationService] Event added to Bloc');

      // Show a SnackBar notification
      _showNotificationSnackBar(notificationModel);
      print('📥 [RealtimeNotificationService] SnackBar triggered');
    } catch (e, stack) {
      print('❌ [RealtimeNotificationService] Error parsing notification: $e');
      print('❌ [RealtimeNotificationService] StackTrace: $stack');
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
