import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getNotifications();
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء جلب الإشعارات'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.markAsRead(id);
        return const Right(unit);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء تحديث حالة الإشعار'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.markAllAsRead();
        return const Right(unit);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء تحديث حالة الإشعارات'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, String?>> deleteNotification(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.deleteNotification(id);
        return Right(message);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء حذف الإشعار'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
