import 'package:equatable/equatable.dart';

class NewParcel extends Equatable {
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String receiverAddress;
  final String parcelType;
  final double weight;
  final String? note;

  const NewParcel({
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverAddress,
    required this.parcelType,
    required this.weight,
    this.note,
  });

  @override
  List<Object?> get props => [
    senderName,
    senderPhone,
    receiverName,
    receiverPhone,
    receiverAddress,
    parcelType,
    weight,
    note,
  ];
}
