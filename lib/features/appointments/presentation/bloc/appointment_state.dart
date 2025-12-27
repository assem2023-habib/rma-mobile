import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment_entity.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentsLoaded extends AppointmentState {
  final AvailableAppointmentsResponse data;

  const AppointmentsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AppointmentBooked extends AppointmentState {
  final dynamic data;

  const AppointmentBooked(this.data);

  @override
  List<Object?> get props => [data];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
