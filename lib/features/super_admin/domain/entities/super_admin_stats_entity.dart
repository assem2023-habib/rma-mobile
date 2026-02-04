import 'package:equatable/equatable.dart';
import '../../../parcels/domain/entities/parcel.dart';

class SuperAdminStatsEntity extends Equatable {
  final int totalParcels;
  final int totalBranches;
  final int totalEmployees;
  final int totalUsers;
  final List<Parcel> recentParcels;

  const SuperAdminStatsEntity({
    required this.totalParcels,
    required this.totalBranches,
    required this.totalEmployees,
    required this.totalUsers,
    required this.recentParcels,
  });

  @override
  List<Object?> get props => [
        totalParcels,
        totalBranches,
        totalEmployees,
        totalUsers,
        recentParcels,
      ];
}
