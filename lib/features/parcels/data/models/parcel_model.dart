import '../../../../core/enums/parcel_status.dart';
import '../../domain/entities/parcel.dart';

class ParcelModel extends Parcel {
  const ParcelModel({
    required super.id,
    required super.senderId,
    required super.senderType,
    required super.routeId,
    required super.fromCity,
    required super.toCity,
    required super.receiverName,
    required super.receiverAddress,
    required super.receiverPhone,
    required super.weight,
    required super.cost,
    required super.isPaid,
    required super.status,
    required super.trackingNumber,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    return ParcelModel(
      id: json['id'],
      senderId: json['sender_id'],
      senderType: json['sender_type'],
      routeId: json['route_id'],
      fromCity: json['from_city'] ?? '',
      toCity: json['to_city'] ?? '',
      receiverName: json['reciver_name'],
      receiverAddress: json['reciver_address'],
      receiverPhone: json['reciver_phone'],
      weight: (json['weight'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      isPaid: json['is_paid'] == 1 || json['is_paid'] == true,
      status: _parseStatus(json['parcel_status']),
      trackingNumber: json['tracking_number'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_type': senderType,
      'route_id': routeId,
      'from_city': fromCity,
      'to_city': toCity,
      'reciver_name': receiverName,
      'reciver_address': receiverAddress,
      'reciver_phone': receiverPhone,
      'weight': weight,
      'cost': cost,
      'is_paid': isPaid ? 1 : 0,
      'parcel_status': status.name,
      'tracking_number': trackingNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static ParcelStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return ParcelStatus.pending;
      case 'inTransit':
      case 'in_transit':
        return ParcelStatus.inTransit;
      case 'delivered':
        return ParcelStatus.delivered;
      case 'cancelled':
        return ParcelStatus.cancelled;
      case 'returned':
        return ParcelStatus.returned;
      default:
        return ParcelStatus.pending;
    }
  }
}
