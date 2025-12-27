import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String birthday,
    required int cityId,
    required String nationalNumber,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> newPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<Either<Failure, void>> verifyEmail(String email, String password);
  Future<Either<Failure, void>> confirmEmailOtp(String email, String otpCode);
}
