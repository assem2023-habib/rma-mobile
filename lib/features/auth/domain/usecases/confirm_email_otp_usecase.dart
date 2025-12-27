import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ConfirmEmailOtpUseCase {
  final AuthRepository repository;

  ConfirmEmailOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String otpCode) async {
    return await repository.confirmEmailOtp(email, otpCode);
  }
}
