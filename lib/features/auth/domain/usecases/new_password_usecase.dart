import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class NewPasswordUseCase {
  final AuthRepository repository;

  NewPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String otpCode,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await repository.newPassword(
      email: email,
      otpCode: otpCode,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }
}
