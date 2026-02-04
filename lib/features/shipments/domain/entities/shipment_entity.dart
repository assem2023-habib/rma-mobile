import 'package:equatable/equatable.dart';

class ShipmentEntity extends Equatable {
  final int id;
  final int routeId;
  final int truckId;
  final int driverId;
  final String status;
  final String? departureTime;
  final String? arrivalTime;
  final String fromCity;
  final String toCity;

  const ShipmentEntity({
    required this.id,
    required this.routeId,
    required this.truckId,
    required this.driverId,
    required this.status,
    this.departureTime,
    this.arrivalTime,
    required this.fromCity,
    required this.toCity,
  });

  @override
  List<Object?> get props => [
        id,
        routeId,
        truckId,
        driverId,
        status,
        departureTime,
        arrivalTime,
        fromCity,
        toCity,
      ];
}
