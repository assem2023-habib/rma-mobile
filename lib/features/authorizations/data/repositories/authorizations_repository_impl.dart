import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/authorizations/domain/entities/authorization_entity.dart';
import 'package:rma_customer/features/authorizations/domain/repositories/authorizations_repository.dart';
import 'package:rma_customer/features/authorizations/data/datasources/authorizations_remote_datasource.dart';
import 'package:rma_customer/features/authorizations/data/models/authorization_model.dart';

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
  Future<Either<Failure, Unit>> requestAuthorization(
    AuthorizationEntity authorization,
  ) async {
    try {
      final model = AuthorizationModel.fromEntity(authorization);
      await remoteDataSource.requestAuthorization(model);
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء إرسال طلب التخويل'));
    }
  }
}
