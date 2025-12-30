import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class SearchUsersUseCase {
  final UserRepository repository;

  SearchUsersUseCase(this.repository);

  Future<Either<Failure, Pagination<UserEntity>>> call({
    required String userName,
    int? page,
  }) async {
    return await repository.searchUsers(userName: userName, page: page);
  }
}
