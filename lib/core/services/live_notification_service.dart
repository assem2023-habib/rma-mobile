import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import '../api/api_config.dart';
import '../api/token_manager.dart';
import 'local_notification_service.dart';

class LiveNotificationService {
  final TokenManager _tokenManager;
  final LocalNotificationService _localNotificationService;

  PusherClient? _pusher;
  Echo? _echo;

  final _eventController = StreamController<dynamic>.broadcast();

  // ignore: close_sinks
  final StreamController<String> _connectionStatusController =
      StreamController<String>.broadcast();

  LiveNotificationService(this._tokenManager, this._localNotificationService);

  Stream<dynamic> get eventStream => _eventController.stream;
  Stream<String> get connectionStream => _connectionStatusController.stream;

  Future<void> init(int userId) async {
    try {
      final token = _tokenManager.getToken();
      if (token == null) return;

      // Reverb Configuration using PusherClient
      PusherOptions options = PusherOptions(
        host: ApiConfig.pusherHost,
        wsPort: ApiConfig.pusherPort,
        wssPort: ApiConfig.pusherPort,
        encrypted: false,
        cluster: ApiConfig.pusherCluster,
        auth: PusherAuth(
          ApiConfig.pusherAuthUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      _pusher = PusherClient(
        ApiConfig.pusherAppKey,
        options,
        autoConnect: true,
        enableLogging: kDebugMode,
      );

      _echo = Echo(client: _pusher, broadcaster: EchoBroadcasterType.Pusher);

      _pusher!.onConnectionStateChange((state) {
        debugPrint(
          "Connection: ${state?.previousState} -> ${state?.currentState}",
        );
        _connectionStatusController.add(state?.currentState ?? 'unknown');
      });

      _pusher!.onConnectionError((error) {
        debugPrint("Connection Error: ${error?.message}");
      });

      // Subscribe to Private User Channel for Notifications
      _echo!
          .private('user.$userId')
          .notification((notification) {
            debugPrint("Notification Received: $notification");
            _handleNotificationEvent(notification);
          })
          .listen('.notification.sent', (event) {
            debugPrint("Private Notification Event: $event");
            _handleNotificationEvent(event);
          });

      // Subscribe to Public Notification Channel
      _echo!.channel('notifications').listen('.notification.sent', (event) {
        debugPrint("Public Notification: $event");
        _handleNotificationEvent(event);
      });
    } catch (e) {
      debugPrint("LiveNotificationService ERROR: $e");
    }
  }

  Future<void> disconnect() async {
    _echo?.disconnect();
    _pusher?.disconnect();
  }

  // Chat Subscription Methods
  Future<void> subscribeToConversation(int conversationId) async {
    try {
      _echo!
          .private('conversation.$conversationId')
          .listen('.message.new', (event) {
            _eventController.add({'type': 'chat_message', 'data': event});
          })
          .listen('message.new', (event) {
            _eventController.add({'type': 'chat_message', 'data': event});
          })
          .listen('.conversation.updated', (event) {
            _eventController.add({
              'type': 'conversation_updated',
              'data': event,
            });
          })
          .listen('conversation.updated', (event) {
            _eventController.add({
              'type': 'conversation_updated',
              'data': event,
            });
          });
      debugPrint("Subscribed to conversation: $conversationId");
    } catch (e) {
      debugPrint("Failed to subscribe to conversation $conversationId: $e");
    }
  }

  Future<void> unsubscribeFromConversation(int conversationId) async {
    try {
      _echo!.leave('conversation.$conversationId');
      debugPrint("Unsubscribed from conversation: $conversationId");
    } catch (e) {
      debugPrint("Failed to unsubscribe from conversation $conversationId: $e");
    }
  }

  void _handleNotificationEvent(dynamic data) {
    try {
      final parsedData = _parseEventData(data);
      _eventController.add({'type': 'notification', 'data': parsedData});

      // Show Local Notification
      _localNotificationService.showNotification(
        id: DateTime.now().millisecond,
        title: parsedData['title'] ?? 'إشعار جديد',
        body: parsedData['message'] ?? '',
        payload: jsonEncode(parsedData),
      );
    } catch (e) {
      debugPrint("Error parsing notification data: $e");
    }
  }

  dynamic _parseEventData(dynamic data) {
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (_) {
        return data;
      }
    }
    return data;
  }
}
