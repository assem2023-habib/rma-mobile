import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats({String? userType});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient dioClient;

  DashboardRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<DashboardStatsModel> getDashboardStats({String? userType}) async {
    try {
      String endpoint = ApiConfig.dashboardStats;
      if (userType == 'super_admin') {
        endpoint = ApiConfig.superAdminStats;
      }
      
      final response = await dioClient.get(endpoint);
      if (response.statusCode == 200) {
        return DashboardStatsModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
