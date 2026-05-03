import '../models/notification_model.dart';
import 'notifications_remote_datasource.dart';

class MockNotificationsRemoteDataSource implements NotificationsRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      NotificationModel(
        id: '1',
        type: 'parcel_status',
        title: 'تم تحديث حالة الطرد',
        message: 'طردك رقم RMA-10001 أصبح الآن في الطريق إليك.',
        data: {'parcel_id': 1},
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        type: 'new_message',
        title: 'رسالة جديدة',
        message: 'لديك رسالة جديدة في المحادثة: استفسار عن طرد متأخر.',
        data: {'conversation_id': 1},
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        readAt: DateTime.now().subtract(const Duration(hours: 23)),
      ),
      NotificationModel(
        id: '3',
        type: 'system',
        title: 'مرحباً بك في RMA',
        message: 'شكراً لانضمامك إلينا. يمكنك الآن البدء بشحن طرودك بكل سهولة.',
        data: null,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<String?> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Notification deleted';
  }
}
