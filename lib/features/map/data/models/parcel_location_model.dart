import '../../domain/entities/parcel_location.dart';
import '../../../../features/routes/data/models/route_model.dart';

class ParcelLocationModel extends ParcelLocation {
  const ParcelLocationModel({
    required super.parcelId,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.lastUpdated,
    super.sourceBranch,
    super.destinationBranch,
  });

  factory ParcelLocationModel.fromJson(Map<String, dynamic> json) {
    final currentLocation = json['current_location'] as Map<String, dynamic>?;

    return ParcelLocationModel(
      parcelId: json['tracking_number'] ?? '',
      latitude: currentLocation != null
          ? double.tryParse(currentLocation['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: currentLocation != null
          ? double.tryParse(currentLocation['longitude'].toString()) ?? 0.0
          : 0.0,
      status: json['status'] ?? '',
      lastUpdated: currentLocation != null
          ? currentLocation['last_updated'] ?? ''
          : '',
      sourceBranch: json['source_branch'] != null
          ? BranchModel.fromJson(json['source_branch'])
          : null,
      destinationBranch: json['destination_branch'] != null
          ? BranchModel.fromJson(json['destination_branch'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tracking_number': parcelId,
      'status': status,
      'current_location': {
        'latitude': latitude,
        'longitude': longitude,
        'last_updated': lastUpdated,
      },
      'source_branch': sourceBranch != null
          ? (sourceBranch as BranchModel).toJson()
          : null,
      'destination_branch': destinationBranch != null
          ? (destinationBranch as BranchModel).toJson()
          : null,
    };
  }
}
