import 'dart:async';
import '../models/authorization_model.dart';

abstract class AuthorizationsRemoteDataSource {
  Future<List<AuthorizationModel>> getAuthorizations();
  Future<AuthorizationModel> getAuthorizationById(int id);
  Future<AuthorizationModel> createAuthorization({
    required int parcelId,
    required String authorizedUserType,
    int? authorizedUserId,
  });
  Future<void> cancelAuthorization(int id);
}

class AuthorizationsRemoteDataSourceImpl
    implements AuthorizationsRemoteDataSource {
  @override
  Future<List<AuthorizationModel>> getAuthorizations() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      AuthorizationModel(
        id: 1,
        userId: 1,
        parcelId: 1,
        authorizedUserId: 2,
        authorizedUserType: 'User',
        authorizedCode: 'XYZ789ABC1',
        status: 'active',
        generatedAt: DateTime.now().subtract(const Duration(days: 2)),
        expiredAt: DateTime.now().add(const Duration(days: 5)),
        parcel: const AuthorizationParcelInfoModel(
          id: 1,
          trackingNumber: 'ABC123DEF4',
          receiverName: 'محمد علي',
        ),
        authorizedUser: const AuthorizedUserInfoModel(
          id: 2,
          userName: 'sara_ahmed',
          firstName: 'سارة',
          lastName: 'أحمد',
        ),
      ),
    ];
  }

  @override
  Future<AuthorizationModel> getAuthorizationById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthorizationModel(
      id: id,
      userId: 1,
      parcelId: 1,
      authorizedUserId: 2,
      authorizedUserType: 'User',
      authorizedCode: 'XYZ789ABC1',
      status: 'active',
      generatedAt: DateTime.now().subtract(const Duration(days: 2)),
      expiredAt: DateTime.now().add(const Duration(days: 5)),
      parcel: const AuthorizationParcelInfoModel(
        id: 1,
        trackingNumber: 'ABC123DEF4',
        receiverName: 'محمد علي',
      ),
      authorizedUser: const AuthorizedUserInfoModel(
        id: 2,
        userName: 'sara_ahmed',
        firstName: 'سارة',
        lastName: 'أحمد',
      ),
    );
  }

  @override
  Future<AuthorizationModel> createAuthorization({
    required int parcelId,
    required String authorizedUserType,
    int? authorizedUserId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthorizationModel(
      id: 3,
      userId: 1,
      parcelId: parcelId,
      authorizedUserId: authorizedUserId,
      authorizedUserType: authorizedUserType,
      authorizedCode: 'NEW_CODE_123',
      status: 'active',
      generatedAt: DateTime.now(),
      expiredAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  @override
  Future<void> cancelAuthorization(int id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
