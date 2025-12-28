import 'package:equatable/equatable.dart';
import '../../../routes/domain/entities/route_entity.dart';

class ParcelLocation extends Equatable {
  final String parcelId;
  final double latitude;
  final double longitude;
  final String status;
  final String lastUpdated;
  final BranchEntity? sourceBranch;
  final BranchEntity? destinationBranch;

  const ParcelLocation({
    required this.parcelId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lastUpdated,
    this.sourceBranch,
    this.destinationBranch,
  });

  @override
  List<Object?> get props => [
        parcelId,
        latitude,
        longitude,
        status,
        lastUpdated,
        sourceBranch,
        destinationBranch,
      ];
}
