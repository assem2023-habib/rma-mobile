import '../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.id,
    required super.fromBranchId,
    required super.toBranchId,
    required super.isActive,
    required super.distancePerKilo,
    required super.days,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      fromBranchId: json['from_branch_id'],
      toBranchId: json['to_branch_id'],
      isActive: json['is_active'] == 1,
      distancePerKilo: json['distance_per_kilo'] is String
          ? num.tryParse(json['distance_per_kilo']) ?? 0
          : (json['distance_per_kilo'] ?? 0),
      days:
          (json['days'] as List<dynamic>?)
              ?.map((d) => RouteDayModel.fromJson(d))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_branch_id': fromBranchId,
      'to_branch_id': toBranchId,
      'is_active': isActive ? 1 : 0,
      'distance_per_kilo': distancePerKilo.toString(),
      'days': days.map((d) => (d as RouteDayModel).toJson()).toList(),
    };
  }
}

class RouteDayModel extends RouteDayEntity {
  const RouteDayModel({
    required super.id,
    required super.dayOfWeek,
    required super.estimatedDepartureTime,
    required super.estimatedArrivalTime,
  });

  factory RouteDayModel.fromJson(Map<String, dynamic> json) {
    return RouteDayModel(
      id: json['id'],
      dayOfWeek: json['day_of_week'],
      estimatedDepartureTime: json['estimated_departur_time'],
      estimatedArrivalTime: json['estimated_arrival_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_of_week': dayOfWeek,
      'estimated_departur_time': estimatedDepartureTime,
      'estimated_arrival_time': estimatedArrivalTime,
    };
  }
}
