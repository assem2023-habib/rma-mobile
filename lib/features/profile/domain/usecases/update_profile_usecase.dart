import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';
import 'package:rma_customer/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    return await repository.updateProfile(
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
    );
  }
}
