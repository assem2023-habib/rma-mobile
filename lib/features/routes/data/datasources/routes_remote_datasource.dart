import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/route_model.dart';

abstract class RoutesRemoteDataSource {
  Future<List<RouteModel>> getRoutes({String? day});
}

class RoutesRemoteDataSourceImpl implements RoutesRemoteDataSource {
  final DioClient dioClient;

  RoutesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<RouteModel>> getRoutes({String? day}) async {
    try {
      final url = day != null ? '${ApiConfig.routes}/$day' : ApiConfig.routes;
      final response = await dioClient.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['routes'];
        return data.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
