import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/appointment_repository.dart';

class BookAppointmentUseCase {
  final AppointmentRepository repository;

  BookAppointmentUseCase(this.repository);

  Future<Either<Failure, dynamic>> call({
    required String trackingNumber,
    required int appointmentId,
    int? userId,
  }) async {
    return await repository.bookAppointment(
      trackingNumber: trackingNumber,
      appointmentId: appointmentId,
      userId: userId,
    );
  }
}
