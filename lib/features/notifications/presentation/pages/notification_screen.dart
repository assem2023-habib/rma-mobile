import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(GetNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('الإشعارات', style: AppTypography.heading3),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<NotificationsBloc>().add(
                      MarkAllNotificationsAsReadEvent(),
                    );
                  },
                  icon: const Icon(Icons.done_all, color: AppColors.primary),
                  tooltip: 'تحديد الكل كمقروء',
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationsLoaded) {
                    if (state.notifications.isEmpty) {
                      return _buildEmptyState();
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
                          return _buildNotificationCard(notification);
                        },
                      ),
                    );
                  } else if (state is NotificationsError) {
                    return _buildErrorState(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationEntity notification) {
    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white),
          ],
        ),
      ),
      onDismissed: (_) {
        context.read<NotificationsBloc>().add(
          DeleteNotificationEvent(notification.id),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
        elevation: notification.isRead ? 0 : 2,
        color: notification.isRead
            ? Colors.white.withValues(alpha: 0.9)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: notification.isRead
              ? BorderSide(color: AppColors.border.withValues(alpha: 0.5))
              : const BorderSide(color: AppColors.primary, width: 0.8),
        ),
        child: ListTile(
          onTap: () => _handleNotificationClick(notification),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing3,
            vertical: AppDimensions.spacing2,
          ),
          leading: Stack(
            children: [
              _buildNotificationIcon(notification.type ?? ''),
              if (!notification.isRead)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            notification.title,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.bold,
              color: notification.isRead
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                style: AppTypography.bodySmall.copyWith(
                  color: notification.isRead
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(notification.createdAt),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(
            Icons.chevron_left,
            color: AppColors.divider,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'parcel_status_updated':
        iconData = Icons.local_shipping_outlined;
        iconColor = AppColors.primary;
        break;
      case 'appointment_confirmed':
        iconData = Icons.event_available_outlined;
        iconColor = AppColors.success;
        break;
      case 'authorization_status_updated':
        iconData = Icons.security_outlined;
        iconColor = AppColors.warning;
        break;
      case 'pickup_reminder':
        iconData = Icons.notification_important_outlined;
        iconColor = AppColors.error;
        break;
      default:
        iconData = Icons.notifications_none_outlined;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          const Text('لا توجد إشعارات حالياً', style: AppTypography.heading3),
          const SizedBox(height: AppDimensions.spacing2),
          const Text(
            'سنقوم بتنبيهك عند وجود تحديثات جديدة',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              message,
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing4),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationsBloc>().add(GetNotificationsEvent());
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return DateFormat('yyyy/MM/dd HH:mm', 'ar').format(dateTime);
    }
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
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(AppDimensions.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildNotificationIcon(notification.type ?? ''),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: AppTypography.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        _formatDateTime(notification.createdAt),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'التفاصيل:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              notification.message,
              style: AppTypography.bodyLarge.copyWith(height: 1.5),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<NotificationsBloc>().add(
                        DeleteNotificationEvent(notification.id),
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('حذف الإشعار'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (!notification.isRead)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<NotificationsBloc>().add(
                          MarkNotificationAsReadEvent(notification.id),
                        );
                      },
                      icon: const Icon(Icons.mark_email_read_outlined),
                      label: const Text('تمت القراءة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
