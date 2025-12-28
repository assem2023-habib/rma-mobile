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
      parcelId: json['tracking_number'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] ?? '',
      lastUpdated: json['current_location'] ?? '',
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
