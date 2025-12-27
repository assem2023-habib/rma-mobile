import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import '../entities/authorization_entity.dart';
import '../repositories/authorizations_repository.dart';

class CreateAuthorizationUseCase {
  final AuthorizationsRepository repository;

  CreateAuthorizationUseCase(this.repository);

  Future<Either<Failure, AuthorizationEntity>> call({
    required int parcelId,
    required String authorizedUserType,
    int? authorizedUserId,
    String? authorizedFirstName,
    String? authorizedLastName,
    String? authorizedPhone,
    String? authorizedNationalNumber,
    String? authorizedAddress,
    int? authorizedCityId,
    String? authorizedBirthday,
  }) async {
    return await repository.createAuthorization(
      parcelId: parcelId,
      authorizedUserType: authorizedUserType,
      authorizedUserId: authorizedUserId,
      authorizedFirstName: authorizedFirstName,
      authorizedLastName: authorizedLastName,
      authorizedPhone: authorizedPhone,
      authorizedNationalNumber: authorizedNationalNumber,
      authorizedAddress: authorizedAddress,
      authorizedCityId: authorizedCityId,
      authorizedBirthday: authorizedBirthday,
    );
  }
}
