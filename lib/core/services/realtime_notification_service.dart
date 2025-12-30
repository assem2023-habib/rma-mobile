import 'dart:convert';
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

import 'package:flutter/foundation.dart';

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
      if (kDebugMode) {
        print(
          '🛰️ [RealtimeNotificationService] User already authenticated, connecting now...',
        );
      }
      _connect(currentState.user.id);
    }

    authBloc.stream.listen((state) {
      if (state is Authenticated) {
        if (kDebugMode) {
          print(
            '🛰️ [RealtimeNotificationService] User authenticated, connecting...',
          );
        }
        _connect(state.user.id);
      } else if (state is Unauthenticated) {
        if (kDebugMode) {
          print(
            '🛰️ [RealtimeNotificationService] User logged out, disconnecting...',
          );
        }
        _disconnect();
      }
    });
  }

  void _connect(int userId) {
    _disconnect(); // Ensure any existing connection is closed

    final token = tokenManager.getToken();
    if (token == null) {
      if (kDebugMode) {
        print(
          '❌ [RealtimeNotificationService] FAILED to connect: Token is null',
        );
      }
      return;
    }

    PusherOptions options = PusherOptions(
      host: '10.43.226.236',
      wsPort: 6001,
      wssPort: 6001,
      encrypted: false,
      auth: PusherAuth(
        'http://10.43.226.236:8000/api/broadcasting/auth',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      print(
        '🛰️ [RealtimeNotificationService] CONNECTING TO LOCAL REVERB: ${options.host}:${options.wsPort}',
      );
    }

    _pusher = PusherClient('z8gmvgvmclvhoezjsfil', options, autoConnect: true);

    _pusher!.onConnectionError((error) {
      if (kDebugMode) {
        print(
          '🔴 [RealtimeNotificationService] CONNECTION ERROR: ${error?.message}',
        );
        print(
          '🔴 [RealtimeNotificationService] Detailed Error: ${error?.exception}',
        );
      }
    });

    _pusher!.onConnectionStateChange((state) {
      if (kDebugMode) {
        print(
          '🔵 [RealtimeNotificationService] Connection State: ${state?.previousState} -> ${state?.currentState}',
        );
      }
      if (state?.currentState == 'CONNECTED') {
        if (kDebugMode) {
          print(
            '✅ [RealtimeNotificationService] SUCCESS: Connected to Reverb!',
          );
        }
        _subscribeToUserChannel(userId);
      }
    });

    _echo = Echo(
      client: _pusher,
      broadcaster: EchoBroadcasterType.Pusher,
      options: {
        'key': 'z8gmvgvmclvhoezjsfil',
        'host': 'http://10.43.226.236:6001',
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
        'disableStats': true,
        'forceTLS': false,
      },
    );
  }

  void _subscribeToUserChannel(int userId) {
    if (_echo == null || _pusher == null) return;

    // We will listen to both common Laravel channel formats to be safe
    final channelNames = ['User.$userId', 'App.Models.User.$userId'];

    for (var channelName in channelNames) {
      if (kDebugMode) {
        print('🛰️ [RealtimeNotificationService] Subscribing to: $channelName');
      }

      final pusherChannel = _pusher!.subscribe('private-$channelName');

      pusherChannel.bind('pusher:subscription_succeeded', (event) {
        if (kDebugMode) {
          print('✅ [RealtimeNotificationService] Subscribed to $channelName');
        }
      });

      pusherChannel.bind('pusher:subscription_error', (event) {
        if (kDebugMode) {
          print(
            '❌ [RealtimeNotificationService] Subscription Error ($channelName): ${event?.data}',
          );
        }
      });

      // Listen for the notification event via Echo
      _echo!.private(channelName).notification((notification) {
        if (kDebugMode) {
          print(
            '📥 [RealtimeNotificationService] ECHO NOTIFICATION: $notification',
          );
        }
        _handleNotification(notification);
      });

      // Direct bind as backup for common event names
      const events = [
        'Illuminate\\Notifications\\Events\\BroadcastNotificationCreated',
        'BroadcastNotificationCreated',
        'notification',
      ];

      for (var event in events) {
        pusherChannel.bind(event, (eventData) {
          if (kDebugMode) {
            print(
              '📥 [RealtimeNotificationService] DIRECT EVENT ($event): ${eventData?.data}',
            );
          }
          _handleRawEvent(eventData);
        });
      }
    }
  }

  void triggerTestNotification() {
    if (kDebugMode) {
      print('🧪 [RealtimeNotificationService] Triggering Test Notification...');
    }
    final testPayload = {
      'id': 'test-uuid-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'test_notification',
      'title': 'إشعار تجريبي 🧪',
      'message': 'هذا إشعار وهمي لاختبار الاتصال والواجهة.',
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
      'data': {'test_key': 'test_value'},
    };
    if (kDebugMode) {
      print('🧪 [RealtimeNotificationService] Test Payload: $testPayload');
    }
    _handleNotification(testPayload);
  }

  void _handleRawEvent(PusherEvent? event) {
    if (event?.data != null) {
      try {
        final decoded = json.decode(event!.data!);
        _handleNotification(decoded);
      } catch (e) {
        if (kDebugMode) {
          print(
            '⚠️ [RealtimeNotificationService] Could not decode event data as JSON, passing as is.',
          );
        }
        _handleNotification(event?.data);
      }
    }
  }

  void _handleNotification(dynamic notification) {
    try {
      if (kDebugMode) {
        print(
          '📥 [RealtimeNotificationService] Handling incoming notification...',
        );
        print('📥 [RealtimeNotificationService] Raw Payload: $notification');
      }

      if (notification is! Map) {
        if (kDebugMode) {
          print('⚠️ [RealtimeNotificationService] Notification is not a Map');
        }
        return;
      }

      final Map<String, dynamic> rawData = Map<String, dynamic>.from(
        notification,
      );

      // Laravel BroadcastNotificationCreated usually has a 'data' field
      // but also top-level 'id' and 'type'.
      final Map<String, dynamic> finalJson = {};

      // Start with the raw data
      finalJson.addAll(rawData);

      // If there's a nested 'data' field, merge its contents into the top level
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

      if (kDebugMode) {
        print('📥 [RealtimeNotificationService] Final Parsed JSON: $finalJson');
      }

      final notificationModel = NotificationModel.fromJson(finalJson);
      if (kDebugMode) {
        print(
          '📥 [RealtimeNotificationService] Created Model: ${notificationModel.id}',
        );
      }

      notificationsBloc.add(NewNotificationReceivedEvent(notificationModel));
      if (kDebugMode) {
        print('📥 [RealtimeNotificationService] Event added to Bloc');
      }

      // Show a SnackBar notification
      _showNotificationSnackBar(notificationModel);
      if (kDebugMode) {
        print('📥 [RealtimeNotificationService] SnackBar triggered');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('❌ [RealtimeNotificationService] Error parsing notification: $e');
        print('❌ [RealtimeNotificationService] StackTrace: $stack');
      }
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
    if (kDebugMode) {
      print(
        '🛰️ [RealtimeNotificationService] Disconnecting and cleaning up...',
      );
    }
    try {
      _echo?.disconnect();
      _pusher?.disconnect();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ [RealtimeNotificationService] Error during disconnect: $e');
      }
    }
    _echo = null;
    _pusher = null;
  }
}
