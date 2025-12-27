import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/core/network/network_info.dart';
import 'package:rma_customer/features/authorizations/domain/entities/authorization_entity.dart';
import 'package:rma_customer/features/authorizations/domain/repositories/authorizations_repository.dart';
import 'package:rma_customer/features/authorizations/data/datasources/authorizations_remote_datasource.dart';

class AuthorizationsRepositoryImpl implements AuthorizationsRepository {
  final AuthorizationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthorizationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AuthorizationEntity>>> getAuthorizations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAuthorizations();
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء جلب التخويلات'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, AuthorizationEntity>> getAuthorizationById(
    int id,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAuthorizationById(id);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء جلب تفاصيل التخويل'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, AuthorizationEntity>> createAuthorization({
    required int parcelId,
    required String authorizedUserType,
    int? authorizedUserId,
    String? authorizedFirstName,
    String? authorizedLastName,
    String? authorizedPhone,
    String? authorizedNationalNumber,
    String? authorizedAddress,
    int? authorizedCityId,
    String? authorizedBirthday,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.createAuthorization(
          parcelId: parcelId,
          authorizedUserType: authorizedUserType,
          authorizedUserId: authorizedUserId,
          authorizedFirstName: authorizedFirstName,
          authorizedLastName: authorizedLastName,
          authorizedPhone: authorizedPhone,
          authorizedNationalNumber: authorizedNationalNumber,
          authorizedAddress: authorizedAddress,
          authorizedCityId: authorizedCityId,
          authorizedBirthday: authorizedBirthday,
        );
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء إنشاء التخويل'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAuthorization(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.cancelAuthorization(id);
        return const Right(unit);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء إلغاء التخويل'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
