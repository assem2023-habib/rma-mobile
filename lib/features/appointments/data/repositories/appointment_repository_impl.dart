import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/appointment_remote_datasource.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AvailableAppointmentsResponse>>
  getAvailableAppointments(String trackingNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAvailableAppointments(
          trackingNumber,
        );
        return Right(result);
      } on ServerException {
        return const Left(
          ServerFailure('Server Error during fetching appointments'),
        );
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> bookAppointment({
    required String trackingNumber,
    required int appointmentId,
    int? userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.bookAppointment(
          trackingNumber: trackingNumber,
          appointmentId: appointmentId,
          userId: userId,
        );
        return Right(result);
      } on ServerException {
        return const Left(
          ServerFailure('Server Error during booking appointment'),
        );
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
