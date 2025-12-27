import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import '../entities/authorization_entity.dart';
import '../repositories/authorizations_repository.dart';

class GetAuthorizationByIdUseCase {
  final AuthorizationsRepository repository;

  GetAuthorizationByIdUseCase(this.repository);

  Future<Either<Failure, AuthorizationEntity>> call(int id) async {
    return await repository.getAuthorizationById(id);
  }
}
