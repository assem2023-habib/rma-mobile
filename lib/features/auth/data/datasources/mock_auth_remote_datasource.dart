import '../models/user_model.dart';
import 'auth_remote_datasource.dart';
import '../../../../core/api/token_manager.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  final TokenManager tokenManager;

  MockAuthRemoteDataSource({required this.tokenManager});

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    String userType = 'customer';
    String firstName = 'أحمد';
    
    if (email == 'admin@gmail.com') {
      userType = 'admin';
      firstName = 'مدير النظام';
    } else if (email == 'customer@gmail.com') {
      userType = 'customer';
      firstName = 'العميل المميز';
    }

    // Default mock user
    final mockUser = UserModel(
      id: 1,
      firstName: firstName,
      lastName: 'المحمد',
      email: email,
      phone: '0931234567',
      userType: userType, // Can be 'customer', 'admin', 'super_admin'
      cityId: 1,
      createdAt: DateTime.now().toIso8601String(),
    );

    await tokenManager.saveToken('mock_token_12345');
    return mockUser;
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
    await Future.delayed(const Duration(seconds: 1));
    
    final mockUser = UserModel(
      id: 2,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      userType: 'customer',
      cityId: cityId,
      nationalNumber: nationalNumber,
      birthday: birthday,
      createdAt: DateTime.now().toIso8601String(),
    );

    await tokenManager.saveToken('mock_token_register_67890');
    return mockUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await tokenManager.deleteToken();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      id: 1,
      firstName: 'أحمد',
      lastName: 'المحمد',
      email: 'test@example.com',
      phone: '0931234567',
      userType: 'customer',
      cityId: 1,
      createdAt: DateTime.now().toIso8601String(),
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

  @override
  Future<void> sendTelegramOtp(int chatId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> verifyTelegramOtp(int chatId, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
