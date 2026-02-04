import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/shipment_model.dart';

abstract class ShipmentRemoteDataSource {
  Future<List<ShipmentModel>> getAdminShipments();
  Future<void> departShipment(int id);
  Future<void> arriveShipment(int id);
}

class ShipmentRemoteDataSourceImpl implements ShipmentRemoteDataSource {
  final DioClient dioClient;

  ShipmentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ShipmentModel>> getAdminShipments() async {
    try {
      final response = await dioClient.get(ApiConfig.adminShipments);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['shipments'];
        return data.map((json) => ShipmentModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> departShipment(int id) async {
    try {
      final response = await dioClient.post('${ApiConfig.adminShipments}/$id/depart');
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> arriveShipment(int id) async {
    try {
      final response = await dioClient.post('${ApiConfig.adminShipments}/$id/arrive');
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
