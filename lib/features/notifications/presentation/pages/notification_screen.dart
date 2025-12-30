import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_details_sheet.dart';
import '../widgets/notification_states.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if not already loaded to preserve local/test notifications during session
    final state = context.read<NotificationsBloc>().state;
    if (state is! NotificationsLoaded) {
      context.read<NotificationsBloc>().add(GetNotificationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppHeader(
        title: 'الإشعارات',
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationsBloc>().add(
                MarkAllNotificationsAsReadEvent(),
              );
            },
            icon: const Icon(Icons.done_all, color: Colors.white),
            tooltip: 'تحديد الكل كمقروء',
          ),
        ],
      ),
      body: ShinyBackground(
        child: BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsLoaded && state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationsLoaded) {
                if (state.notifications.isEmpty) {
                  return const NotificationEmptyState();
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotificationsBloc>().add(
                      GetNotificationsEvent(),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.spacing4),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return NotificationCard(
                        notification: notification,
                        onTap: () => _handleNotificationClick(notification),
                        onDismissed: (_) {
                          context.read<NotificationsBloc>().add(
                            DeleteNotificationEvent(notification.id),
                          );
                        },
                      );
                    },
                  ),
                );
              } else if (state is NotificationsError) {
                return NotificationErrorState(
                  message: state.message,
                  onRetry: () {
                    context.read<NotificationsBloc>().add(
                      GetNotificationsEvent(),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _handleNotificationClick(NotificationEntity notification) {
    if (!notification.isRead) {
      context.read<NotificationsBloc>().add(
        MarkNotificationAsReadEvent(notification.id),
      );
    }
    _showNotificationDetails(notification);
  }

  void _showNotificationDetails(NotificationEntity notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationDetailsSheet(
        notification: notification,
        onDelete: () {
          Navigator.pop(context);
          context.read<NotificationsBloc>().add(
            DeleteNotificationEvent(notification.id),
          );
        },
        onMarkAsRead: !notification.isRead
            ? () {
                Navigator.pop(context);
                context.read<NotificationsBloc>().add(
                  MarkNotificationAsReadEvent(notification.id),
                );
              }
            : null,
      ),
    );
  }
}
