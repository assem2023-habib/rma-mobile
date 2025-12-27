import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class VerifyTelegramOtpUseCase {
  final AuthRepository repository;

  VerifyTelegramOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(int chatId, String otp) {
    return repository.verifyTelegramOtp(chatId, otp);
  }
}
