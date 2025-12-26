import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
