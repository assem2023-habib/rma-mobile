import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String phoneNumber,
    String? profileImageUrl,
  });
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
