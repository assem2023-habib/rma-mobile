import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, AvailableAppointmentsResponse>>
  getAvailableAppointments(String trackingNumber);
  Future<Either<Failure, dynamic>> bookAppointment({
    required String trackingNumber,
    required int appointmentId,
    int? userId,
  });
}
