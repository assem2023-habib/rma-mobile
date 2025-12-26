import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/authorization_entity.dart';

abstract class AuthorizationsRepository {
  Future<Either<Failure, List<AuthorizationEntity>>> getAuthorizations();
  Future<Either<Failure, Unit>> requestAuthorization(AuthorizationEntity authorization);
}
