import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
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
  Future<void> sendTelegramOtp(int chatId);
  Future<void> verifyTelegramOtp(int chatId, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
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
    try {
      final response = await dioClient.post(
        ApiConfig.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
          'birthday': birthday,
          'city_id': cityId,
          'national_number': nationalNumber,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.get(ApiConfig.logout);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get(ApiConfig.currentUser);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final response = await dioClient.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> newPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.newPassword,
        data: {
          'email': email,
          'otp_code': otpCode,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> verifyEmail(String email, String password) async {
    try {
      final response = await dioClient.post(
        ApiConfig.verifyEmail,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> confirmEmailOtp(String email, String otpCode) async {
    try {
      final response = await dioClient.post(
        ApiConfig.confirmEmailOtp,
        data: {'email': email, 'otp_code': otpCode},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> sendTelegramOtp(int chatId) async {
    try {
      final response = await dioClient.post(
        ApiConfig.sendTelegramOtp,
        data: {'chat_id': chatId},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> verifyTelegramOtp(int chatId, String otp) async {
    try {
      final response = await dioClient.post(
        ApiConfig.verifyTelegramOtp,
        data: {'chat_id': chatId, 'otp': otp},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
