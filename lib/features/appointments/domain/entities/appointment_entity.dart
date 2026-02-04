import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int id;
  final int branchId;
  final String date;
  final String time;
  final bool booked;
  final String? status;

  const AppointmentEntity({
    required this.id,
    required this.branchId,
    required this.date,
    required this.time,
    required this.booked,
    this.status,
  });

  @override
  List<Object?> get props => [id, branchId, date, time, booked, status];
}

class AvailableAppointmentsResponse extends Equatable {
  final bool success;
  final AppointmentParcel parcel;
  final List<AppointmentEntity> availableAppointments;

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
