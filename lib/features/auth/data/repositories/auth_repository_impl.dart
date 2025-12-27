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
  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String birthday,
    required int cityId,
    required String nationalNumber,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          phone: phone,
          birthday: birthday,
          cityId: cityId,
          nationalNumber: nationalNumber,
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

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure('Server Error during forgot password'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> newPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.newPassword(
          email: email,
          otpCode: otpCode,
          newPassword: newPassword,
          newPasswordConfirmation: newPasswordConfirmation,
        );
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure('Server Error during new password'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyEmail(email, password);
        return const Right(null);
      } on ServerException {
        return const Left(
          ServerFailure('Server Error during email verification'),
        );
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> confirmEmailOtp(
    String email,
    String otpCode,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.confirmEmailOtp(email, otpCode);
        return const Right(null);
      } on ServerException {
        return const Left(
          ServerFailure('Server Error during OTP confirmation'),
        );
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
