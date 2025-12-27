import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/parcel_model.dart';

abstract class ParcelRemoteDataSource {
  Future<List<ParcelModel>> getParcels();
  Future<ParcelModel> getParcelById(int id);
  Future<ParcelModel> createParcel({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  });
  Future<ParcelModel> updateParcel({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  });
  Future<void> deleteParcel(int id);
}

class ParcelRemoteDataSourceImpl implements ParcelRemoteDataSource {
  final DioClient dioClient;

  ParcelRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ParcelModel>> getParcels() async {
    try {
      final response = await dioClient.get(ApiConfig.parcels);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['parcels'];
        return data.map((json) => ParcelModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ParcelModel> getParcelById(int id) async {
    try {
      final response = await dioClient.get('${ApiConfig.parcels}/$id');
      if (response.statusCode == 200) {
        return ParcelModel.fromJson(response.data['data']['parcel']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ParcelModel> createParcel({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.parcels,
        data: {
          'route_id': routeId,
          'reciver_name': receiverName,
          'reciver_address': receiverAddress,
          'reciver_phone': receiverPhone,
          'weight': weight,
          'is_paid': isPaid ? 1 : 0,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ParcelModel.fromJson(response.data['data']['parcel']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ParcelModel> updateParcel({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  }) async {
    try {
      final response = await dioClient.put(
        '${ApiConfig.parcels}/$id',
        data: {
          if (receiverName != null) 'reciver_name': receiverName,
          if (receiverAddress != null) 'reciver_address': receiverAddress,
          if (receiverPhone != null) 'reciver_phone': receiverPhone,
          if (weight != null) 'weight': weight,
        },
      );
      if (response.statusCode == 200) {
        return ParcelModel.fromJson(response.data['data']['parcel']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteParcel(int id) async {
    try {
      final response = await dioClient.delete('${ApiConfig.parcels}/$id');
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
