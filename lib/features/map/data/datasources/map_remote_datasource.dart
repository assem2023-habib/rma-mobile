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
  Future<ParcelLocationModel> getParcelLocation(String trackingNumber) async {
    try {
      final response = await dioClient.get(
        '${ApiConfig.parcelLocation}/$trackingNumber/location',
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          return ParcelLocationModel.fromJson(response.data['data']);
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'لم يتم العثور على موقع الطرد',
          );
        }
      } else {
        throw ServerException(message: 'حدث خطأ في الاتصال بالسيرفر');
      }
    } catch (e) {
      if (e is ServerException) rethrow;

      // Handle Dio 404 error and extract message if available
      if (e.toString().contains('404')) {
        throw ServerException(
          message: 'عذراً، لا توجد بيانات تتبع متاحة لهذا الطرد حالياً',
        );
      }

      throw ServerException(message: 'خطأ في معالجة بيانات الموقع: $e');
    }
  }
}
