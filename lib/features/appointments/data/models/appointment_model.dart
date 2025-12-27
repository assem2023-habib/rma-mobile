import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.branchId,
    required super.date,
    required super.time,
    required super.booked,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      branchId: json['branch_id'],
      date: json['date'],
      time: json['time'],
      booked: json['booked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'date': date,
      'time': time,
      'booked': booked,
    };
  }
}

class AvailableAppointmentsResponseModel extends AvailableAppointmentsResponse {
  const AvailableAppointmentsResponseModel({
    required super.success,
    required super.parcel,
    required super.availableAppointments,
  });

  factory AvailableAppointmentsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AvailableAppointmentsResponseModel(
      success: json['success'],
      parcel: AppointmentParcelModel.fromJson(json['parcel']),
      availableAppointments: (json['available_appointments'] as List)
          .map((i) => AppointmentModel.fromJson(i))
          .toList(),
    );
  }
}

class BookAppointmentResponseModel {
  final bool success;
  final String message;
  final AppointmentModel appointment;

  const BookAppointmentResponseModel({
    required this.success,
    required this.message,
    required this.appointment,
  });

  factory BookAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return BookAppointmentResponseModel(
      success: json['success'],
      message: json['message'],
      appointment: AppointmentModel.fromJson(json['appointment']),
    );
  }
}

class AppointmentParcelModel extends AppointmentParcel {
  const AppointmentParcelModel({
    required super.id,
    required super.trackingNumber,
    required super.receiverName,
    required super.parcelStatus,
  });

  factory AppointmentParcelModel.fromJson(Map<String, dynamic> json) {
    return AppointmentParcelModel(
      id: json['id'],
      trackingNumber: json['tracking_number'],
      receiverName:
          json['reciver_name'], // Note the spelling in JSON: 'reciver_name'
      parcelStatus: json['parcel_status'],
    );
  }
}
