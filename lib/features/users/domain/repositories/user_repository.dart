import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, Pagination<UserEntity>>> searchUsers({
    required String userName,
    int? page,
  });
  Future<Either<Failure, Pagination<UserEntity>>> getUsers({int? page});
}
