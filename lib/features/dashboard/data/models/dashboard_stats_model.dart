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
      usersCount: int.tryParse(json['users_count']?.toString() ?? '0') ?? 0,
      totalParcels: int.tryParse(parcels?['total']?.toString() ?? '0') ?? 0,
      parcelsByStatus:
          byStatus?.map(
            (key, value) => MapEntry(key, int.tryParse(value.toString()) ?? 0),
          ) ??
          {},
      ratesCount: int.tryParse(json['rates_count']?.toString() ?? '0') ?? 0,
      branchesCount:
          int.tryParse(json['branches_count']?.toString() ?? '0') ?? 0,
      shipmentsCount:
          int.tryParse(json['shipments_count']?.toString() ?? '0') ?? 0,
      trucksCount: int.tryParse(json['trucks_count']?.toString() ?? '0') ?? 0,
      countriesCount:
          int.tryParse(locations?['countries_count']?.toString() ?? '0') ?? 0,
      citiesCount:
          int.tryParse(locations?['cities_count']?.toString() ?? '0') ?? 0,
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
