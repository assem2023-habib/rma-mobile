import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.usersCount,
    required super.totalParcels,
    required super.parcelsByStatus,
    required super.ratesCount,
    required super.branchesCount,
    required super.shipmentsCount,
    required super.trucksCount,
    required super.countriesCount,
    required super.citiesCount,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final parcels = json['parcels'] as Map<String, dynamic>?;
    final byStatus = parcels?['by_status'] as Map<String, dynamic>?;
    final locations = json['locations'] as Map<String, dynamic>?;

    return DashboardStatsModel(
      usersCount: json['users_count'] ?? 0,
      totalParcels: parcels?['total'] ?? 0,
      parcelsByStatus:
          byStatus?.map((key, value) => MapEntry(key, value as int)) ?? {},
      ratesCount: json['rates_count'] ?? 0,
      branchesCount: json['branches_count'] ?? 0,
      shipmentsCount: json['shipments_count'] ?? 0,
      trucksCount: json['trucks_count'] ?? 0,
      countriesCount: locations?['countries_count'] ?? 0,
      citiesCount: locations?['cities_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users_count': usersCount,
      'parcels': {'total': totalParcels, 'by_status': parcelsByStatus},
      'rates_count': ratesCount,
      'branches_count': branchesCount,
      'shipments_count': shipmentsCount,
      'trucks_count': trucksCount,
      'locations': {
        'countries_count': countriesCount,
        'cities_count': citiesCount,
      },
    };
  }
}
