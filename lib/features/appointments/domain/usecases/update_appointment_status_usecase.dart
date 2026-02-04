import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointmentStatusUseCase implements UseCase<void, UpdateAppointmentStatusParams> {
  final AppointmentRepository repository;

  UpdateAppointmentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateAppointmentStatusParams params) async {
    return await repository.updateAppointmentStatus(params.id, params.status);
  }
}

class UpdateAppointmentStatusParams {
  final int id;
  final String status;

  UpdateAppointmentStatusParams({required this.id, required this.status});
}
