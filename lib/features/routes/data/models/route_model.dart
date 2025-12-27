import '../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    required super.name,
    required super.fromCity,
    required super.toCity,
    required super.status,
    required super.date,
    required super.driverName,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      name: json['name'],
      fromCity: json['from_city'] ?? json['from'],
      toCity: json['to_city'] ?? json['to'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      driverName: json['driver_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'from_city': fromCity,
      'to_city': toCity,
      'status': status,
      'date': date.toIso8601String(),
      'driver_name': driverName,
    };
  }
}
