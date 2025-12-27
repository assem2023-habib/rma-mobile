import 'package:rma_customer/features/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int cityId,
  });
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int cityId,
  }) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 1,
      firstName: firstName,
      lastName: lastName,
      email: 'user@example.com',
      userName: 'user123',
      phone: phone,
      cityId: cityId,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
