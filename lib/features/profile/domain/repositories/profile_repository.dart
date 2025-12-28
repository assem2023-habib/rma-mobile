import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    String? userName,
    required String phone,
    String? birthday,
    required int cityId,
    String? nationalNumber,
    String? address,
    dynamic imageProfile, // Can be File or String path
  });
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
