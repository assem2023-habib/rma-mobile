import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/user_remote_datasource.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Pagination<UserEntity>>> searchUsers({
    required String userName,
    int? page,
  }) async {
    return await _getRemoteData(
      () => remoteDataSource.searchUsers(userName: userName, page: page),
    );
  }

  @override
  Future<Either<Failure, Pagination<UserEntity>>> getUsers({int? page}) async {
    return await _getRemoteData(() => remoteDataSource.getUsers(page: page));
  }

  Future<Either<Failure, Pagination<UserEntity>>> _getRemoteData(
    Future<Pagination<UserEntity>> Function() call,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await call();
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure());
      } catch (e) {
        return const Left(
          ServerFailure('حدث خطأ غير متوقع أثناء جلب البيانات'),
        );
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
