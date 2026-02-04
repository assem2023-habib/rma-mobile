import '../../domain/entities/shipment_entity.dart';

class ShipmentModel extends ShipmentEntity {
  const ShipmentModel({
    required super.id,
    required super.routeId,
    required super.truckId,
    required super.driverId,
    required super.status,
    super.departureTime,
    super.arrivalTime,
    required super.fromCity,
    required super.toCity,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'],
      routeId: json['route_id'],
      truckId: json['truck_id'],
      driverId: json['driver_id'],
      status: json['status'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      fromCity: json['from_city'] ?? '',
      toCity: json['to_city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_id': routeId,
      'truck_id': truckId,
      'driver_id': driverId,
      'status': status,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
    };
  }
}
