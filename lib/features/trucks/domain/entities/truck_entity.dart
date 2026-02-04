import 'package:equatable/equatable.dart';

class TruckEntity extends Equatable {
  final int id;
  final String plateNumber;
  final String model;
  final String status; // 'available', 'unavailable'
  final int branchId;

  const TruckEntity({
    required this.id,
    required this.plateNumber,
    required this.model,
    required this.status,
    required this.branchId,
  });

  @override
  List<Object?> get props => [id, plateNumber, model, status, branchId];
}
