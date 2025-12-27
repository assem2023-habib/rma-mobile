import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
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
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int cityId,
  }) async {
    try {
      final response = await dioClient.put(
        ApiConfig.currentUser,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'city_id': cityId,
        },
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
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
