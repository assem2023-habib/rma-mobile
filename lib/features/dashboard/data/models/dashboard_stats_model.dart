import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.activeParcels,
    required super.deliveredParcels,
    required super.pendingParcels,
    required super.rating,
    required super.activeParcelsChange,
    required super.deliveredParcelsChange,
    required super.pendingParcelsChange,
    required super.ratingChange,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      activeParcels: json['active_parcels'] ?? 0,
      deliveredParcels: json['delivered_parcels'] ?? 0,
      pendingParcels: json['pending_parcels'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      activeParcelsChange: json['active_parcels_change'] ?? '',
      deliveredParcelsChange: json['delivered_parcels_change'] ?? '',
      pendingParcelsChange: json['pending_parcels_change'] ?? '',
      ratingChange: json['rating_change'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_parcels': activeParcels,
      'delivered_parcels': deliveredParcels,
      'pending_parcels': pendingParcels,
      'rating': rating,
      'active_parcels_change': activeParcelsChange,
      'delivered_parcels_change': deliveredParcelsChange,
      'pending_parcels_change': pendingParcelsChange,
      'rating_change': ratingChange,
    };
  }
}
