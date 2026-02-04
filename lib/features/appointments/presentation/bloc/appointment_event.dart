import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class GetAvailableAppointmentsRequested extends AppointmentEvent {
  final String trackingNumber;

  const GetAvailableAppointmentsRequested(this.trackingNumber);

  @override
  List<Object?> get props => [trackingNumber];
}

class BookAppointmentRequested extends AppointmentEvent {
  final String trackingNumber;
  final int appointmentId;
  final int? userId;

  const BookAppointmentRequested({
    required this.trackingNumber,
    required this.appointmentId,
    this.userId,
  });

  @override
  List<Object?> get props => [trackingNumber, appointmentId, userId];
}

class GetAdminAppointmentsEvent extends AppointmentEvent {}

class UpdateAppointmentStatusEvent extends AppointmentEvent {
  final int id;
  final String status;

  const UpdateAppointmentStatusEvent({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}
