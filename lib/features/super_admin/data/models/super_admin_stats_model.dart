
import 'package:rma_customer/features/super_admin/domain/entities/super_admin_stats_entity.dart';

import '../../../parcels/data/models/parcel_model.dart';

class SuperAdminStatsModel extends SuperAdminStatsEntity {
  const SuperAdminStatsModel({
    required super.totalParcels,
    required super.totalBranches,
    required super.totalEmployees,
    required super.totalUsers,
    required super.recentParcels,
    required super.parcelGrowth,
    required super.branchPerformance,
  });

  factory SuperAdminStatsModel.fromJson(Map<String, dynamic> json) {
    final statsJson = json['stats'] ?? json;
    return SuperAdminStatsModel(
      totalParcels: statsJson['total_parcels'] ?? 0,
      totalBranches: statsJson['total_branches'] ?? 0,
      totalEmployees: statsJson['total_employees'] ?? 0,
      totalUsers: statsJson['total_users'] ?? 0,
      recentParcels: (statsJson['recent_parcels'] as List?)
              ?.map((i) => ParcelModel.fromJson(i))
              .toList() ??
          [],
      parcelGrowth: (statsJson['parcel_growth'] as List?)
              ?.map((i) => ParcelGrowthModel.fromJson(i))
              .toList() ??
          _mockParcelGrowth(),
      branchPerformance: (statsJson['branch_performance'] as List?)
              ?.map((i) => BranchPerformanceModel.fromJson(i))
              .toList() ??
          _mockBranchPerformance(),
    );
  }

  static List<ParcelGrowthData> _mockParcelGrowth() {
    return [
      const ParcelGrowthData(month: 'يناير', count: 120),
      const ParcelGrowthData(month: 'فبراير', count: 210),
      const ParcelGrowthData(month: 'مارس', count: 180),
      const ParcelGrowthData(month: 'أبريل', count: 320),
      const ParcelGrowthData(month: 'مايو', count: 250),
      const ParcelGrowthData(month: 'يونيو', count: 400),
    ];
  }

  static List<BranchPerformanceData> _mockBranchPerformance() {
    return [
      const BranchPerformanceData(branchName: 'فرع المزة', parcelsCount: 450),
      const BranchPerformanceData(branchName: 'فرع المالكي', parcelsCount: 320),
      const BranchPerformanceData(branchName: 'فرع الشعلان', parcelsCount: 280),
      const BranchPerformanceData(branchName: 'فرع الجسر', parcelsCount: 150),
    ];
  }
}

class ParcelGrowthModel extends ParcelGrowthData {
  const ParcelGrowthModel({required super.month, required super.count});

  factory ParcelGrowthModel.fromJson(Map<String, dynamic> json) {
    return ParcelGrowthModel(
      month: json['month'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class BranchPerformanceModel extends BranchPerformanceData {
  const BranchPerformanceModel({
    required super.branchName,
    required super.parcelsCount,
  });

  factory BranchPerformanceModel.fromJson(Map<String, dynamic> json) {
    return BranchPerformanceModel(
      branchName: json['branch_name'] ?? '',
      parcelsCount: json['parcels_count'] ?? 0,
    );
  }
}
