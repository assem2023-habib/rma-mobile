import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/authorization_entity.dart';

abstract class AuthorizationsRepository {
  Future<Either<Failure, List<AuthorizationEntity>>> getAuthorizations();
  Future<Either<Failure, AuthorizationEntity>> getAuthorizationById(int id);
  Future<Either<Failure, AuthorizationEntity>> createAuthorization({
    required int parcelId,
    required String authorizedUserType,
    int? authorizedUserId,
  });
  Future<Either<Failure, Unit>> cancelAuthorization(int id);
}
