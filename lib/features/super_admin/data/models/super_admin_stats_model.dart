import '../entities/super_admin_stats_entity.dart';
import '../../../parcels/data/models/parcel_model.dart';

class SuperAdminStatsModel extends SuperAdminStatsEntity {
  const SuperAdminStatsModel({
    required super.totalParcels,
    required super.totalBranches,
    required super.totalEmployees,
    required super.totalUsers,
    required super.recentParcels,
  });

  factory SuperAdminStatsModel.fromJson(Map<String, dynamic> json) {
    final statsJson = json['stats'];
    return SuperAdminStatsModel(
      totalParcels: statsJson['total_parcels'],
      totalBranches: statsJson['total_branches'],
      totalEmployees: statsJson['total_employees'],
      totalUsers: statsJson['total_users'],
      recentParcels: (statsJson['recent_parcels'] as List)
          .map((i) => ParcelModel.fromJson(i))
          .toList(),
    );
  }
}
