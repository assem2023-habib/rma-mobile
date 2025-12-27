import '../models/route_model.dart';

abstract class RoutesRemoteDataSource {
  Future<List<RouteModel>> getRoutes();
}

class RoutesRemoteDataSourceImpl implements RoutesRemoteDataSource {
  @override
  Future<List<RouteModel>> getRoutes() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      RouteModel(
        id: 1,
        name: 'مسار بغداد - البصرة',
        fromCity: 'بغداد',
        toCity: 'البصرة',
        status: 'نشط',
        date: DateTime.now(),
        driverName: 'محمد علي',
      ),
      RouteModel(
        id: 2,
        name: 'مسار أربيل - بغداد',
        fromCity: 'أربيل',
        toCity: 'بغداد',
        status: 'مكتمل',
        date: DateTime.now().subtract(const Duration(days: 1)),
        driverName: 'أحمد جاسم',
      ),
    ];
  }
}
