import '../models/dashboard_stats_model.dart';
import 'dashboard_remote_datasource.dart';

class MockDashboardRemoteDataSource implements DashboardRemoteDataSource {
  @override
  Future<DashboardStatsModel> getDashboardStats({String? userType}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (userType == 'super_admin' || userType == 'admin') {
      return const DashboardStatsModel(
        usersCount: 150,
        totalParcels: 1200,
        parcelsByStatus: {
          'pending': 45,
          'in_transit': 120,
          'delivered': 950,
          'returned': 85,
        },
        ratesCount: 320,
        branchesCount: 12,
        shipmentsCount: 85,
        trucksCount: 24,
        employeesCount: 56,
        countriesCount: 5,
        citiesCount: 25,
      );
    } else {
      // Customer Stats
      return const DashboardStatsModel(
        usersCount: 0,
        totalParcels: 15,
        parcelsByStatus: {
          'pending': 2,
          'in_transit': 3,
          'delivered': 10,
        },
        ratesCount: 5,
        branchesCount: 0,
        shipmentsCount: 0,
        trucksCount: 0,
        employeesCount: 0,
        countriesCount: 0,
        citiesCount: 0,
      );
    }
  }
}
