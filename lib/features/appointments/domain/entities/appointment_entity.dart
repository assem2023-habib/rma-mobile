import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final int id;
  final int branchId;
  final String date;
  final String time;
  final bool booked;

  const Appointment({
    required this.id,
    required this.branchId,
    required this.date,
    required this.time,
    required this.booked,
  });

  @override
  List<Object?> get props => [id, branchId, date, time, booked];
}

class AvailableAppointmentsResponse extends Equatable {
  final bool success;
  final AppointmentParcel parcel;
  final List<Appointment> availableAppointments;

  const AvailableAppointmentsResponse({
    required this.success,
    required this.parcel,
    required this.availableAppointments,
  });

  @override
  List<Object?> get props => [success, parcel, availableAppointments];
}

class AppointmentParcel extends Equatable {
  final int id;
  final String trackingNumber;
  final String receiverName;
  final String parcelStatus;

  const AppointmentParcel({
    required this.id,
    required this.trackingNumber,
    required this.receiverName,
    required this.parcelStatus,
  });

  @override
  List<Object?> get props => [id, trackingNumber, receiverName, parcelStatus];
}
