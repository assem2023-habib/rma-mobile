import 'package:equatable/equatable.dart';
import '../../../../core/enums/parcel_status.dart';

class Parcel extends Equatable {
  final String id;
  final String trackingNumber;
  final String senderName;
  final String receiverName;
  final String fromCity;
  final String toCity;
  final ParcelStatus status;
  final DateTime createdAt;
  final double weight;
  final double price;

  const Parcel({
    required this.id,
    required this.trackingNumber,
    required this.senderName,
    required this.receiverName,
    required this.fromCity,
    required this.toCity,
    required this.status,
    required this.createdAt,
    required this.weight,
    required this.price,
  });

  @override
  List<Object> get props => [
    id,
    trackingNumber,
    senderName,
    receiverName,
    fromCity,
    toCity,
    status,
    createdAt,
    weight,
    price,
  ];
}
