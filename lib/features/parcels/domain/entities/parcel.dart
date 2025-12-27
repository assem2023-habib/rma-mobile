import 'package:equatable/equatable.dart';
import '../../../../core/enums/parcel_status.dart';

class Parcel extends Equatable {
  final int id;
  final int senderId;
  final String senderType;
  final int routeId;
  final String fromCity;
  final String toCity;
  final String receiverName;
  final String receiverAddress;
  final String receiverPhone;
  final double weight;
  final double cost;
  final bool isPaid;
  final ParcelStatus status;
  final String trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Parcel({
    required this.id,
    required this.senderId,
    required this.senderType,
    required this.routeId,
    required this.fromCity,
    required this.toCity,
    required this.receiverName,
    required this.receiverAddress,
    required this.receiverPhone,
    required this.weight,
    required this.cost,
    required this.isPaid,
    required this.status,
    required this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    senderType,
    routeId,
    fromCity,
    toCity,
    receiverName,
    receiverAddress,
    receiverPhone,
    weight,
    cost,
    isPaid,
    status,
    trackingNumber,
    createdAt,
    updatedAt,
  ];
}
