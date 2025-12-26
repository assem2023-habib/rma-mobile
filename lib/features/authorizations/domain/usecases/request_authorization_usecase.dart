import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/authorization_entity.dart';
import '../repositories/authorizations_repository.dart';

class RequestAuthorizationUseCase {
  final AuthorizationsRepository repository;

  RequestAuthorizationUseCase(this.repository);

  Future<Either<Failure, Unit>> call(AuthorizationEntity authorization) async {
    return await repository.requestAuthorization(authorization);
  }
}
