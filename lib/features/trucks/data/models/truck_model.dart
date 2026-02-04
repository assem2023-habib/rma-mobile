import '../../domain/entities/truck_entity.dart';

class TruckModel extends TruckEntity {
  const TruckModel({
    required super.id,
    required super.plateNumber,
    required super.model,
    required super.status,
    required super.branchId,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      id: json['id'],
      plateNumber: json['plate_number'],
      model: json['model'],
      status: json['status'],
      branchId: json['branch_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate_number': plateNumber,
      'model': model,
      'status': status,
      'branch_id': branchId,
    };
  }
}
