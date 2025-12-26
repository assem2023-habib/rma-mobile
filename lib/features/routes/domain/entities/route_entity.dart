import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String from;
  final String to;
  final String status;
  final DateTime date;
  final String driverName;

  const RouteEntity({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.status,
    required this.date,
    required this.driverName,
  });

  @override
  List<Object?> get props => [id, name, from, to, status, date, driverName];
}
