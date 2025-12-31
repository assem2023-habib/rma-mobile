import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../api/token_manager.dart';
import 'local_notification_service.dart';

class LiveNotificationService {
  final TokenManager _tokenManager;
  final LocalNotificationService _localNotificationService;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final _eventController = StreamController<dynamic>.broadcast();

  // ignore: close_sinks
  final StreamController<String> _connectionStatusController =
      StreamController<String>.broadcast();

  LiveNotificationService(this._tokenManager, this._localNotificationService);

  Stream<dynamic> get eventStream => _eventController.stream;
  Stream<String> get connectionStream => _connectionStatusController.stream;

  Future<void> init(int userId) async {
    try {
      await _pusher.init(
        apiKey: "z8gmvgvmclvhoezjsfil",
        cluster: "mt1",
        useTLS: false,
        host: "10.43.226.236",
        port: 6001,
        onEvent: _onEvent,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onSubscriptionError: _onSubscriptionError,
        onDecryptionFailure: _onDecryptionFailure,
        onMemberAdded: _onMemberAdded,
        onMemberRemoved: _onMemberRemoved,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onAuthorizer: _onAuthorizer,
      );

      await _pusher.connect();

      final channelName = "private-User.$userId";
      await _pusher.subscribe(channelName: channelName);
    } catch (e) {
      debugPrint("LiveNotificationService ERROR: $e");
    }
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }

  void _onEvent(PusherEvent event) {
    debugPrint("Pusher Event: ${event.eventName} - ${event.data}");
    // Filter for the specific notification event
    if (event.eventName ==
        "Illuminate\\Notifications\\Events\\BroadcastNotificationCreated") {
      try {
        final data = jsonDecode(event.data);
        _eventController.add(data);

        // Show Local Notification
        _localNotificationService.showNotification(
          id: DateTime.now().millisecond,
          title: data['title'] ?? 'تنبيه جديد',
          body: data['body'] ?? data['message'] ?? '',
          payload: jsonEncode(data),
        );
      } catch (e) {
        debugPrint("Error parsing notification data: $e");
      }
    }
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("Subscribed to: $channelName");
  }

  void _onSubscriptionError(String message, dynamic e) {
    debugPrint("Subscription Error: $message - $e");
  }

  void _onDecryptionFailure(String channelName, String reason) {
    debugPrint("Decryption Failure: $channelName - $reason");
  }

  void _onMemberAdded(String channelName, PusherMember member) {
    debugPrint("Member Added: $channelName - ${member.userId}");
  }

  void _onMemberRemoved(String channelName, PusherMember member) {
    debugPrint("Member Removed: $channelName - ${member.userId}");
  }

  void _onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $previousState -> $currentState");
    _connectionStatusController.add(currentState.toString());
  }

  void _onError(String message, int? code, dynamic e) {
    debugPrint("Error: $message code: $code e: $e");
  }

  Future<dynamic> _onAuthorizer(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    try {
      final token = _tokenManager.getToken();
      if (token == null) {
        throw Exception("No token available for auth");
      }

      final url = Uri.parse("http://10.43.226.236:8000/api/broadcasting/auth");
      final response = await http.post(
        url,
        headers: {
          "Content-Type":
              "application/json", // Pusher usually expects form-data or JSON?
          // User said: Headers: Authorization: Bearer {USER_TOKEN}.
          // Laravel Echo default is often form-data but here explicitly User said "Result expected is object with auth key".
          // Let's use standard JSON if that's what Laravel expects, OR standard form-url-encoded.
          // Standard Pusher auth is x-www-form-urlencoded: socket_id=...&channel_name=...
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {"socket_id": socketId, "channel_name": channelName},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Auth Failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      debugPrint("Authorizer Error: $e");
      rethrow;
    }
  }
}
