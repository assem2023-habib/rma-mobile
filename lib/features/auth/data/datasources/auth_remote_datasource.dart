import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
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
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> forgotPassword(String email);
  Future<void> newPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<void> verifyEmail(String email, String password);
  Future<void> confirmEmailOtp(String email, String otpCode);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return const UserModel(
      id: 1,
      firstName: 'أحمد',
      lastName: 'محمد',
      email: 'user@example.com',
      phone: '0912345678',
      cityId: 1,
    );
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String birthday,
    required int cityId,
    required String nationalNumber,
  }) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 2,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      cityId: cityId,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserModel(
      id: 1,
      firstName: 'أحمد',
      lastName: 'محمد',
      email: 'user@example.com',
      phone: '0912345678',
      cityId: 1,
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> newPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> verifyEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> confirmEmailOtp(String email, String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
