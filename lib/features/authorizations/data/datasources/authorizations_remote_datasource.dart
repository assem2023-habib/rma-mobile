import 'dart:async';
import '../../../../core/enums/authorization_status.dart';
import '../models/authorization_model.dart';

abstract class AuthorizationsRemoteDataSource {
  Future<List<AuthorizationModel>> getAuthorizations();
  Future<AuthorizationModel> getAuthorizationById(int id);
  Future<AuthorizationModel> createAuthorization({
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
  });
  Future<void> cancelAuthorization(int id);
}

class AuthorizationsRemoteDataSourceImpl
    implements AuthorizationsRemoteDataSource {
  @override
  Future<List<AuthorizationModel>> getAuthorizations() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      AuthorizationModel(
        id: 1,
        userId: 1,
        parcelId: 1,
        authorizedUserId: 2,
        authorizedUserType: 'user',
        authorizedCode: 'AUTH_123456',
        status: AuthorizationStatus.active,
        generatedAt: DateTime.now().subtract(const Duration(days: 2)),
        expiredAt: DateTime.now().add(const Duration(days: 5)),
        parcel: const AuthorizationParcelInfoModel(
          id: 1,
          trackingNumber: 'PKG-2024-001',
          receiverName: 'سارة علي',
        ),
        authorizedUser: const AuthorizedUserInfoModel(
          id: 2,
          userName: 'ahmad_hassan',
          firstName: 'أحمد',
          lastName: 'حسن',
        ),
      ),
      AuthorizationModel(
        id: 2,
        userId: 1,
        parcelId: 2,
        authorizedUserType: 'guest',
        authorizedCode: 'AUTH_654321',
        status: AuthorizationStatus.pending,
        generatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        expiredAt: DateTime.now().add(const Duration(days: 7)),
        parcel: const AuthorizationParcelInfoModel(
          id: 2,
          trackingNumber: 'PKG-2024-002',
          receiverName: 'ليلى حسن',
        ),
      ),
    ];
  }

  @override
  Future<AuthorizationModel> getAuthorizationById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AuthorizationModel(
      id: id,
      userId: 1,
      parcelId: 1,
      authorizedUserId: 2,
      authorizedUserType: 'user',
      authorizedCode: 'AUTH_123456',
      status: AuthorizationStatus.active,
      generatedAt: DateTime.now().subtract(const Duration(days: 2)),
      expiredAt: DateTime.now().add(const Duration(days: 5)),
      parcel: const AuthorizationParcelInfoModel(
        id: 1,
        trackingNumber: 'PKG-2024-001',
        receiverName: 'سارة علي',
      ),
      authorizedUser: const AuthorizedUserInfoModel(
        id: 2,
        userName: 'ahmad_hassan',
        firstName: 'أحمد',
        lastName: 'حسن',
      ),
    );
  }

  @override
  Future<AuthorizationModel> createAuthorization({
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
    await Future.delayed(const Duration(seconds: 1));
    return AuthorizationModel(
      id: 3,
      userId: 1,
      parcelId: parcelId,
      authorizedUserId: authorizedUserId,
      authorizedUserType: authorizedUserType,
      authorizedCode: 'NEW_CODE_123',
      status: AuthorizationStatus.active,
      generatedAt: DateTime.now(),
      expiredAt: DateTime.now().add(const Duration(days: 7)),
      authorizedUser: authorizedUserType == 'guest'
          ? AuthorizedUserInfoModel(
              id: 0,
              userName: '$authorizedFirstName $authorizedLastName',
              firstName: authorizedFirstName ?? 'guest',
              lastName: authorizedLastName ?? '',
            )
          : null,
    );
  }

  @override
  Future<void> cancelAuthorization(int id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
