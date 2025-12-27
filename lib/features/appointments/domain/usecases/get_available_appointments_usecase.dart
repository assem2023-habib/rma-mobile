import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/appointment_repository.dart';
import '../entities/appointment_entity.dart';

class GetAvailableAppointmentsUseCase {
  final AppointmentRepository repository;

  GetAvailableAppointmentsUseCase(this.repository);

  Future<Either<Failure, AvailableAppointmentsResponse>> call(
    String trackingNumber,
  ) async {
    return await repository.getAvailableAppointments(trackingNumber);
  }
}
