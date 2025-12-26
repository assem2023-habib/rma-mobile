import '../../domain/entities/new_parcel.dart';

class NewParcelModel extends NewParcel {
  const NewParcelModel({
    required super.senderName,
    required super.senderPhone,
    required super.receiverName,
    required super.receiverPhone,
    required super.receiverAddress,
    required super.parcelType,
    required super.weight,
    super.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender_name': senderName,
      'sender_phone': senderPhone,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'receiver_address': receiverAddress,
      'parcel_type': parcelType,
      'weight': weight,
      'note': note,
    };
  }

  factory NewParcelModel.fromEntity(NewParcel entity) {
    return NewParcelModel(
      senderName: entity.senderName,
      senderPhone: entity.senderPhone,
      receiverName: entity.receiverName,
      receiverPhone: entity.receiverPhone,
      receiverAddress: entity.receiverAddress,
      parcelType: entity.parcelType,
      weight: entity.weight,
      note: entity.note,
    );
  }
}
