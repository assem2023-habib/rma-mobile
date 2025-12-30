import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import '../../core/services/live_notification_service.dart';
import '../../injection_container.dart';

class LiveNotificationWrapper extends StatefulWidget {
  final Widget child;

  const LiveNotificationWrapper({super.key, required this.child});

  @override
  State<LiveNotificationWrapper> createState() =>
      _LiveNotificationWrapperState();
}

class _LiveNotificationWrapperState extends State<LiveNotificationWrapper> {
  final LiveNotificationService _liveNotificationService =
      sl<LiveNotificationService>();

  @override
  void initState() {
    super.initState();
    _liveNotificationService.eventStream.listen((data) {
      // Convert raw data to NotificationEntity
      // Data format from user:
      /*
        {
          "id": "uuid-notification-id",
          "title": "...",
          "body": "...",
          "type": "...",
          "data": { ... }
        }
       */
      try {
        final notification = NotificationEntity(
          id: data['id'] ?? DateTime.now().toString(),
          title: data['title'] ?? 'New Notification',
          message: data['body'] ?? '',
          type: data['type'],
          data: data['data'],
          createdAt: DateTime.now(),
        );

        if (mounted) {
          context.read<NotificationsBloc>().add(
            NotificationReceivedEvent(notification),
          );
        }
      } catch (e) {
        debugPrint("Error processing notification: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Initialize Live Service
          _liveNotificationService.init(state.user.id);
        } else if (state is Unauthenticated) {
          _liveNotificationService.disconnect();
        }
      },
      child: widget.child,
    );
  }
}
