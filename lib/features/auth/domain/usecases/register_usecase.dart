import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    return await repository.register(name, email, password, phoneNumber);
  }
}
