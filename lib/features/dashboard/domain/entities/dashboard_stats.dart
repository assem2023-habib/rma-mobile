import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int activeParcels;
  final int deliveredParcels;
  final int pendingParcels;
  final double rating;
  final String activeParcelsChange;
  final String deliveredParcelsChange;
  final String pendingParcelsChange;
  final String ratingChange;

  const DashboardStats({
    required this.activeParcels,
    required this.deliveredParcels,
    required this.pendingParcels,
    required this.rating,
    required this.activeParcelsChange,
    required this.deliveredParcelsChange,
    required this.pendingParcelsChange,
    required this.ratingChange,
  });

  @override
  List<Object?> get props => [
        activeParcels,
        deliveredParcels,
        pendingParcels,
        rating,
        activeParcelsChange,
        deliveredParcelsChange,
        pendingParcelsChange,
        ratingChange,
      ];
}
