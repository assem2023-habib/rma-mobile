import '../../../../core/enums/parcel_status.dart';
import '../models/parcel_model.dart';

abstract class ParcelRemoteDataSource {
  Future<List<ParcelModel>> getParcels();
  Future<ParcelModel> getParcelById(String id);
}

class ParcelRemoteDataSourceImpl implements ParcelRemoteDataSource {
  @override
  Future<List<ParcelModel>> getParcels() async {
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      ParcelModel(
        id: '1',
        trackingNumber: 'PKG-2024-001',
        senderName: 'أحمد محمد',
        receiverName: 'سارة علي',
        fromCity: 'دمشق',
        toCity: 'حلب',
        status: ParcelStatus.inTransit,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        weight: 2.5,
        price: 15000,
      ),
      ParcelModel(
        id: '2',
        trackingNumber: 'PKG-2024-002',
        senderName: 'ياسين محمود',
        receiverName: 'ليلى حسن',
        fromCity: 'حمص',
        toCity: 'اللاذقية',
        status: ParcelStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        weight: 1.0,
        price: 8000,
      ),
      ParcelModel(
        id: '3',
        trackingNumber: 'PKG-2024-003',
        senderName: 'عمر خالد',
        receiverName: 'مريم يوسف',
        fromCity: 'طرطوس',
        toCity: 'دمشق',
        status: ParcelStatus.pending,
        createdAt: DateTime.now(),
        weight: 5.0,
        price: 25000,
      ),
    ];
  }

  @override
  Future<ParcelModel> getParcelById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ParcelModel(
      id: id,
      trackingNumber: 'PKG-2024-001',
      senderName: 'أحمد محمد',
      receiverName: 'سارة علي',
      fromCity: 'دمشق',
      toCity: 'حلب',
      status: ParcelStatus.inTransit,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      weight: 2.5,
      price: 15000,
    );
  }
}
