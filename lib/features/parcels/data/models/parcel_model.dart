import '../../../../core/enums/parcel_status.dart';
import '../../domain/entities/parcel.dart';

class ParcelModel extends Parcel {
  const ParcelModel({
    required super.id,
    required super.trackingNumber,
    required super.senderName,
    required super.receiverName,
    required super.fromCity,
    required super.toCity,
    required super.status,
    required super.createdAt,
    required super.weight,
    required super.price,
  });

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    return ParcelModel(
      id: json['id'],
      trackingNumber: json['tracking_number'],
      senderName: json['sender_name'],
      receiverName: json['receiver_name'],
      fromCity: json['from_city'],
      toCity: json['to_city'],
      status: _parseStatus(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      weight: (json['weight'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_number': trackingNumber,
      'sender_name': senderName,
      'receiver_name': receiverName,
      'from_city': fromCity,
      'to_city': toCity,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'weight': weight,
      'price': price,
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
