import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';
import 'package:rma_customer/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String firstName,
    required String lastName,
    String? email,
    String? userName,
    required String phone,
    String? birthday,
    required int cityId,
    String? nationalNumber,
    String? address,
    dynamic imageProfile,
  }) async {
    return await repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      userName: userName,
      phone: phone,
      birthday: birthday,
      cityId: cityId,
      nationalNumber: nationalNumber,
      address: address,
      imageProfile: imageProfile,
    );
  }
}
