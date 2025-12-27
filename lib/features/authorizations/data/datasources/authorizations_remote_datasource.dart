import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
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
  final DioClient dioClient;

  AuthorizationsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<AuthorizationModel>> getAuthorizations() async {
    try {
      final response = await dioClient.get(ApiConfig.authorizations);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AuthorizationModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<AuthorizationModel> getAuthorizationById(int id) async {
    try {
      final response = await dioClient.get('${ApiConfig.authorizations}/$id');
      if (response.statusCode == 200) {
        return AuthorizationModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
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
    try {
      final Map<String, dynamic> requestData = {'parcel_id': parcelId};

      if (authorizedUserType.toLowerCase() == 'user') {
        requestData['authorized_user_id'] = authorizedUserId;
      } else {
        requestData['authorized_guest'] = [
          {
            'first_name': authorizedFirstName,
            'last_name': authorizedLastName,
            'phone': authorizedPhone,
            'address': authorizedAddress,
            'national_number': authorizedNationalNumber,
            'city_id': authorizedCityId,
            'birthday': authorizedBirthday,
          },
        ];
      }

      final response = await dioClient.post(
        ApiConfig.authorizations,
        data: requestData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthorizationModel.fromJson(
          response.data['data']['authorization'],
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> cancelAuthorization(int id) async {
    try {
      final response = await dioClient.delete(
        '${ApiConfig.authorizations}/$id',
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
