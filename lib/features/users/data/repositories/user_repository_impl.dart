import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/user_remote_datasource.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

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
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.searchUsers(
          userName: userName,
          page: page,
        );
        return Right(remoteUsers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Pagination<UserEntity>>> getUsers({int? page}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getUsers(page: page);
        return Right(remoteUsers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
