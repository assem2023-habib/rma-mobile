import 'package:equatable/equatable.dart';

class ParcelLocation extends Equatable {
  final String parcelId;
  final double latitude;
  final double longitude;
  final String status;
  final String lastUpdated;

  const ParcelLocation({
    required this.parcelId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [parcelId, latitude, longitude, status, lastUpdated];
}
