import '../../domain/entities/parcel_location.dart';

class ParcelLocationModel extends ParcelLocation {
  const ParcelLocationModel({
    required super.parcelId,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.lastUpdated,
  });

  factory ParcelLocationModel.fromJson(Map<String, dynamic> json) {
    return ParcelLocationModel(
      parcelId: json['parcelId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parcelId': parcelId,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'lastUpdated': lastUpdated,
    };
  }
}
