import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/super_admin_stats_model.dart';
import '../../../parcels/data/models/parcel_model.dart';

abstract class SuperAdminRemoteDataSource {
  Future<SuperAdminStatsModel> getSuperAdminStats();
  Future<List<ParcelModel>> getAllParcels(int page);
}

class SuperAdminRemoteDataSourceImpl implements SuperAdminRemoteDataSource {
  final DioClient dioClient;

  SuperAdminRemoteDataSourceImpl(this.dioClient);

  @override
  Future<SuperAdminStatsModel> getSuperAdminStats() async {
    try {
      final response = await dioClient.get(ApiConfig.superAdminStats);
      if (response.data['status'] == 'success') {
        return SuperAdminStatsModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'فشل تحميل الإحصائيات');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ParcelModel>> getAllParcels(int page) async {
    try {
      final response = await dioClient.get(
        ApiConfig.superAdminAllParcels,
        queryParameters: {'page': page},
      );
      if (response.data['status'] == 'success') {
        final List parcelsJson = response.data['data']['parcels']['data'] ?? [];
        return parcelsJson.map((json) => ParcelModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'فشل تحميل الطرود');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
