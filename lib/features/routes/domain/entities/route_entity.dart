import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final int id;
  final int fromBranchId;
  final int toBranchId;
  final bool isActive;
  final num distancePerKilo;
  final List<RouteDayEntity> days;
  final BranchEntity? fromBranch;
  final BranchEntity? toBranch;

  const RouteEntity({
    required this.id,
    required this.fromBranchId,
    required this.toBranchId,
    required this.isActive,
    required this.distancePerKilo,
    required this.days,
    this.fromBranch,
    this.toBranch,
  });

  @override
  List<Object?> get props => [
    id,
    fromBranchId,
    toBranchId,
    isActive,
    distancePerKilo,
    days,
    fromBranch,
    toBranch,
  ];
}

class BranchEntity extends Equatable {
  final int id;
  final String branchName;
  final int? cityId;
  final String address;
  final double latitude;
  final double longitude;

  const BranchEntity({
    required this.id,
    required this.branchName,
    this.cityId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    id,
    branchName,
    cityId,
    address,
    latitude,
    longitude,
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
