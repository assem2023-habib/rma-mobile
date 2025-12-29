import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<String?> deleteNotification(String id);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final DioClient dioClient;

  NotificationsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dioClient.get(ApiConfig.notifications);
      if (response.statusCode == 200) {
        // The real structure is response.data['notifications']['data']
        final List<dynamic> data = response.data['notifications']['data'];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      final response = await dioClient.post(
        '${ApiConfig.notifications}/$id/read',
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final response = await dioClient.post(
        '${ApiConfig.notifications}/read-all',
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<String?> deleteNotification(String id) async {
    try {
      final response = await dioClient.delete('${ApiConfig.notifications}/$id');
      if (response.statusCode == 200) {
        return response.data['message'] as String?;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
