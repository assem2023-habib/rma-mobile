import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, Unit>> markAsRead(String id);
  Future<Either<Failure, Unit>> markAllAsRead();
  Future<Either<Failure, String?>> deleteNotification(String id);
}
