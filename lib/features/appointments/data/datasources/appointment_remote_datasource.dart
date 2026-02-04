import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AvailableAppointmentsResponseModel> getAvailableAppointments(
    String trackingNumber,
  );
  Future<BookAppointmentResponseModel> bookAppointment({
    required String trackingNumber,
    required int appointmentId,
    int? userId,
  });
  Future<List<AppointmentModel>> getAdminAppointments();
  Future<void> updateAppointmentStatus(int id, String status);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final DioClient dioClient;

  AppointmentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<AppointmentModel>> getAdminAppointments() async {
    try {
      final response = await dioClient.get(ApiConfig.appointments);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['appointments'];
        return data.map((json) => AppointmentModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateAppointmentStatus(int id, String status) async {
    try {
      final response = await dioClient.post(
        '${ApiConfig.appointments}/$id/status',
        data: {'status': status},
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<AvailableAppointmentsResponseModel> getAvailableAppointments(
    String trackingNumber,
  ) async {
    try {
      final response = await dioClient.get(
        '${ApiConfig.appointments}/$trackingNumber',
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return AvailableAppointmentsResponseModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<BookAppointmentResponseModel> bookAppointment({
    required String trackingNumber,
    required int appointmentId,
    int? userId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'tracking_number': trackingNumber,
        'appointment_id': appointmentId,
      };

      if (userId != null) {
        data['user_id'] = userId;
      }

      final response = await dioClient.post(
        ApiConfig.bookAppointment,
        data: data,
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return BookAppointmentResponseModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
