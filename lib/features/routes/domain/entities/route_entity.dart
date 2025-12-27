import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final int id;
  final String name;
  final String fromCity;
  final String toCity;
  final String status;
  final DateTime date;
  final String driverName;

  const RouteEntity({
    required this.id,
    required this.name,
    required this.fromCity,
    required this.toCity,
    required this.status,
    required this.date,
    required this.driverName,
  });

  @override
  List<Object?> get props => [id, name, fromCity, toCity, status, date, driverName];
}
