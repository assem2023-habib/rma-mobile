import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/authorization_entity.dart';
import '../repositories/authorizations_repository.dart';

class GetAuthorizationsUseCase {
  final AuthorizationsRepository repository;

  GetAuthorizationsUseCase(this.repository);

  Future<Either<Failure, List<AuthorizationEntity>>> call() async {
    return await repository.getAuthorizations();
  }
}
