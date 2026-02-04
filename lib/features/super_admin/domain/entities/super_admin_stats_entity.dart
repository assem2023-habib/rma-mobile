import 'package:equatable/equatable.dart';
import '../../../parcels/domain/entities/parcel.dart';

class SuperAdminStatsEntity extends Equatable {
  final int totalParcels;
  final int totalBranches;
  final int totalEmployees;
  final int totalUsers;
  final List<Parcel> recentParcels;
  final List<ParcelGrowthData> parcelGrowth;
  final List<BranchPerformanceData> branchPerformance;

  const SuperAdminStatsEntity({
    required this.totalParcels,
    required this.totalBranches,
    required this.totalEmployees,
    required this.totalUsers,
    required this.recentParcels,
    required this.parcelGrowth,
    required this.branchPerformance,
  });

  @override
  List<Object?> get props => [
        totalParcels,
        totalBranches,
        totalEmployees,
        totalUsers,
        recentParcels,
        parcelGrowth,
        branchPerformance,
      ];
}

class ParcelGrowthData extends Equatable {
  final String month;
  final int count;

  const ParcelGrowthData({required this.month, required this.count});

  @override
  List<Object?> get props => [month, count];
}

class BranchPerformanceData extends Equatable {
  final String branchName;
  final int parcelsCount;

  const BranchPerformanceData({
    required this.branchName,
    required this.parcelsCount,
  });

  @override
  List<Object?> get props => [branchName, parcelsCount];
}
