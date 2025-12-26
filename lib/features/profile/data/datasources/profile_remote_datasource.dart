import 'package:rma_customer/features/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    required String name,
    required String phoneNumber,
    String? profileImageUrl,
  });
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<UserModel> updateProfile({
    required String name,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '1',
      name: name,
      email: 'user@example.com',
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
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
