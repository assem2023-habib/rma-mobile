import 'dart:async';
import '../models/authorization_model.dart';

abstract class AuthorizationsRemoteDataSource {
  Future<List<AuthorizationModel>> getAuthorizations();
  Future<void> requestAuthorization(AuthorizationModel authorization);
}

class AuthorizationsRemoteDataSourceImpl implements AuthorizationsRemoteDataSource {
  @override
  Future<List<AuthorizationModel>> getAuthorizations() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      AuthorizationModel(
        id: '1',
        title: 'تخويل استلام طرد',
        status: 'مكتمل',
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'تخويل للسيد محمد باستلام الطرد رقم #12345',
      ),
      AuthorizationModel(
        id: '2',
        title: 'تخويل شحن دولي',
        status: 'قيد الانتظار',
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'طلب تخويل لشحن مواد إلكترونية إلى الأردن',
      ),
    ];
  }

  @override
  Future<void> requestAuthorization(AuthorizationModel authorization) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
