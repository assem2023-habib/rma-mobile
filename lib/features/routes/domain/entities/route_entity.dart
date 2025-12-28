import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final int id;
  final int fromBranchId;
  final int toBranchId;
  final bool isActive;
  final num distancePerKilo;
  final List<RouteDayEntity> days;

  const RouteEntity({
    required this.id,
    required this.fromBranchId,
    required this.toBranchId,
    required this.isActive,
    required this.distancePerKilo,
    required this.days,
  });

  @override
  List<Object?> get props => [
    id,
    fromBranchId,
    toBranchId,
    isActive,
    distancePerKilo,
    days,
  ];
}

class RouteDayEntity extends Equatable {
  final int id;
  final String dayOfWeek;
  final String estimatedDepartureTime;
  final String estimatedArrivalTime;

  const RouteDayEntity({
    required this.id,
    required this.dayOfWeek,
    required this.estimatedDepartureTime,
    required this.estimatedArrivalTime,
  });

  @override
  List<Object?> get props => [
    id,
    dayOfWeek,
    estimatedDepartureTime,
    estimatedArrivalTime,
  ];
}
