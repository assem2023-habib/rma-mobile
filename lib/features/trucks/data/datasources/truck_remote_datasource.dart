import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/truck_model.dart';

abstract class TruckRemoteDataSource {
  Future<List<TruckModel>> getAllTrucks();
  Future<TruckModel> getTruckDetails(int id);
  Future<TruckModel> toggleTruckStatus(int id);
}

class TruckRemoteDataSourceImpl implements TruckRemoteDataSource {
  final DioClient dioClient;

  TruckRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<TruckModel>> getAllTrucks() async {
    try {
      final response = await dioClient.get(ApiConfig.adminTrucks);
      if (response.data['status'] == 'success') {
        final List trucksJson = response.data['data']['trucks'] ?? [];
        return trucksJson.map((json) => TruckModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'فشل تحميل الشاحنات');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TruckModel> getTruckDetails(int id) async {
    try {
      final response = await dioClient.get('${ApiConfig.adminTrucks}/$id');
      if (response.data['status'] == 'success') {
        return TruckModel.fromJson(response.data['data']['truck']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'فشل تحميل تفاصيل الشاحنة');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TruckModel> toggleTruckStatus(int id) async {
    try {
      final response = await dioClient.post('${ApiConfig.adminTrucks}/$id/toggle-status');
      if (response.data['status'] == 'success') {
        return TruckModel.fromJson(response.data['data']['truck']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'فشل تبديل حالة الشاحنة');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
