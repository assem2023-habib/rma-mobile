import '../../../../core/enums/parcel_status.dart';
import '../models/parcel_model.dart';

abstract class ParcelRemoteDataSource {
  Future<List<ParcelModel>> getParcels();
  Future<ParcelModel> getParcelById(int id);
  Future<ParcelModel> createParcel({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  });
  Future<ParcelModel> updateParcel({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  });
  Future<void> deleteParcel(int id);
}

class ParcelRemoteDataSourceImpl implements ParcelRemoteDataSource {
  @override
  Future<List<ParcelModel>> getParcels() async {
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      ParcelModel(
        id: 1,
        senderId: 1,
        senderType: 'User',
        routeId: 1,
        fromCity: 'دمشق',
        toCity: 'حلب',
        receiverName: 'سارة علي',
        receiverAddress: 'حلب، شارع النيل',
        receiverPhone: '+963912345679',
        weight: 2.5,
        cost: 15000,
        isPaid: false,
        status: ParcelStatus.inTransit,
        trackingNumber: 'PKG-2024-001',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ParcelModel(
        id: 2,
        senderId: 1,
        senderType: 'User',
        routeId: 2,
        fromCity: 'حلب',
        toCity: 'اللاذقية',
        receiverName: 'ليلى حسن',
        receiverAddress: 'اللاذقية، الكورنيش',
        receiverPhone: '+963987654321',
        weight: 1.0,
        cost: 8000,
        isPaid: true,
        status: ParcelStatus.delivered,
        trackingNumber: 'PKG-2024-002',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<ParcelModel> getParcelById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ParcelModel(
      id: id,
      senderId: 1,
      senderType: 'User',
      routeId: 1,
      fromCity: 'دمشق',
      toCity: 'حلب',
      receiverName: 'سارة علي',
      receiverAddress: 'حلب، شارع النيل',
      receiverPhone: '+963912345679',
      weight: 2.5,
      cost: 15000,
      isPaid: false,
      status: ParcelStatus.inTransit,
      trackingNumber: 'PKG-2024-001',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    );
  }

  @override
  Future<ParcelModel> createParcel({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return ParcelModel(
      id: 3,
      senderId: 1,
      senderType: 'User',
      routeId: routeId,
      fromCity: 'دمشق', // Mocked city
      toCity: 'حلب', // Mocked city
      receiverName: receiverName,
      receiverAddress: receiverAddress,
      receiverPhone: receiverPhone,
      weight: weight,
      cost: weight * 5000, // Example calculation
      isPaid: isPaid,
      status: ParcelStatus.pending,
      trackingNumber: 'PKG-NEW-001',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<ParcelModel> updateParcel({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return ParcelModel(
      id: id,
      senderId: 1,
      senderType: 'User',
      routeId: 1,
      fromCity: 'دمشق',
      toCity: 'حلب',
      receiverName: receiverName ?? 'سارة علي',
      receiverAddress: receiverAddress ?? 'حلب، شارع النيل',
      receiverPhone: receiverPhone ?? '+963912345679',
      weight: weight ?? 2.5,
      cost: (weight ?? 2.5) * 5000,
      isPaid: false,
      status: ParcelStatus.inTransit,
      trackingNumber: 'PKG-2024-001',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteParcel(int id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
