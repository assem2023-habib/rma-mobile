import 'package:dartz/dartz.dart';
import 'package:rma_customer/features/auth/domain/repositories/auth_repository.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';
import 'package:rma_customer/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(email, password);
        return Right(remoteUser);
      } on ServerException {
        return const Left(ServerFailure('Server Error during login'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.register(
          name,
          email,
          password,
          phoneNumber,
        );
        return Right(remoteUser);
      } on ServerException {
        return const Left(ServerFailure('Server Error during registration'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Server Error during logout'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getCurrentUser();
        return Right(remoteUser);
      } on ServerException {
        return const Left(ServerFailure('Server Error fetching user info'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
