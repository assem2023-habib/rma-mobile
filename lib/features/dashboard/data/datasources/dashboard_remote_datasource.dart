import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    // Mocking API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    return const DashboardStatsModel(
      activeParcels: 12,
      deliveredParcels: 48,
      pendingParcels: 5,
      rating: 4.8,
      activeParcelsChange: '+3',
      deliveredParcelsChange: '+8',
      pendingParcelsChange: '-2',
      ratingChange: '+0.2',
    );
  }
}
