import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/pagination_model.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<PaginationModel<UserModel>> searchUsers({
    required String userName,
    int? page,
  });
  Future<PaginationModel<UserModel>> getUsers({int? page});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PaginationModel<UserModel>> searchUsers({
    required String userName,
    int? page,
  }) async {
    try {
      final response = await dioClient.get(
        ApiConfig.searchUsers,
        queryParameters: {
          'user_name': userName,
          if (page != null) 'page': page,
        },
      );
      if (response.statusCode == 200) {
        return PaginationModel.fromJson(
          response.data['data']['users'],
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<PaginationModel<UserModel>> getUsers({int? page}) async {
    try {
      final response = await dioClient.get(
        ApiConfig.users,
        queryParameters: {
          if (page != null) 'page': page,
        },
      );
      if (response.statusCode == 200) {
        return PaginationModel.fromJson(
          response.data['data']['users'],
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
