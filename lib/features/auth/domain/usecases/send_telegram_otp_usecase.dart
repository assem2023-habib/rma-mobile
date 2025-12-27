import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendTelegramOtpUseCase {
  final AuthRepository repository;

  SendTelegramOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(int chatId) {
    return repository.sendTelegramOtp(chatId);
  }
}
