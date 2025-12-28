import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import 'package:rma_customer/features/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
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
    String? email,
    String? userName,
    required String phone,
    String? birthday,
    required int cityId,
    String? nationalNumber,
    String? address,
    dynamic imageProfile,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'city_id': cityId,
        if (email != null) 'email': email,
        if (userName != null) 'user_name': userName,
        if (birthday != null) 'birthday': birthday,
        if (nationalNumber != null) 'national_number': nationalNumber,
        if (address != null) 'address': address,
      };

      FormData formData = FormData.fromMap(data);

      if (imageProfile != null) {
        if (imageProfile is File) {
          formData.files.add(
            MapEntry(
              'image_profile',
              await MultipartFile.fromFile(
                imageProfile.path,
                filename: imageProfile.path.split('/').last,
              ),
            ),
          );
        } else if (imageProfile is String && imageProfile.isNotEmpty) {
          formData.files.add(
            MapEntry(
              'image_profile',
              await MultipartFile.fromFile(
                imageProfile,
                filename: imageProfile.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await dioClient.post(
        ApiConfig.updateProfile,
        data: formData,
      );

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        return UserModel.fromJson(userData);
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
