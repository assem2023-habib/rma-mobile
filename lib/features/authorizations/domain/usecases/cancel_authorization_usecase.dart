import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import '../repositories/authorizations_repository.dart';

class CancelAuthorizationUseCase {
  final AuthorizationsRepository repository;

  CancelAuthorizationUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.cancelAuthorization(id);
  }
}
