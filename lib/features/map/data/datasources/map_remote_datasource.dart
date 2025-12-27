import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/parcel_location_model.dart';

abstract class MapRemoteDataSource {
  Future<ParcelLocationModel> getParcelLocation(String parcelId);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final DioClient dioClient;

  MapRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ParcelLocationModel> getParcelLocation(String parcelId) async {
    try {
      final response = await dioClient.get('${ApiConfig.parcelLocation}/$parcelId/location');
      if (response.statusCode == 200) {
        return ParcelLocationModel.fromJson(response.data['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
