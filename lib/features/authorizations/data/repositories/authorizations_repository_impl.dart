import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/authorizations/domain/entities/authorization_entity.dart';
import 'package:rma_customer/features/authorizations/domain/repositories/authorizations_repository.dart';
import 'package:rma_customer/features/authorizations/data/datasources/authorizations_remote_datasource.dart';

class AuthorizationsRepositoryImpl implements AuthorizationsRepository {
  final AuthorizationsRemoteDataSource remoteDataSource;

  AuthorizationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AuthorizationEntity>>> getAuthorizations() async {
    try {
      final remoteData = await remoteDataSource.getAuthorizations();
      return Right(remoteData);
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء جلب التخويلات'));
    }
  }

  @override
  Future<Either<Failure, AuthorizationEntity>> getAuthorizationById(
    int id,
  ) async {
    try {
      final remoteData = await remoteDataSource.getAuthorizationById(id);
      return Right(remoteData);
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء جلب تفاصيل التخويل'));
    }
  }

  @override
  Future<Either<Failure, AuthorizationEntity>> createAuthorization({
    required int parcelId,
    required String authorizedUserType,
    int? authorizedUserId,
  }) async {
    try {
      final remoteData = await remoteDataSource.createAuthorization(
        parcelId: parcelId,
        authorizedUserType: authorizedUserType,
        authorizedUserId: authorizedUserId,
      );
      return Right(remoteData);
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء إنشاء التخويل'));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAuthorization(int id) async {
    try {
      await remoteDataSource.cancelAuthorization(id);
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء إلغاء التخويل'));
    }
  }
}
