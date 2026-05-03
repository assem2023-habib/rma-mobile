import '../models/parcel_model.dart';
import 'parcel_remote_datasource.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/enums/parcel_status.dart';

class MockParcelRemoteDataSource implements ParcelRemoteDataSource {
  final List<ParcelModel> _mockParcels = [
    ParcelModel(
      id: 1,
      senderId: 1,
      senderType: 'customer',
      routeId: 1,
      fromCity: 'دمشق',
      toCity: 'حلب',
      receiverName: 'محمد العلي',
      receiverAddress: 'حي الشهباء، شارع النيل',
      receiverPhone: '0944556677',
      weight: 2.5,
      cost: 15000.0,
      isPaid: true,
      status: ParcelStatus.pending,
      trackingNumber: 'RMA-10001',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ParcelModel(
      id: 2,
      senderId: 1,
      senderType: 'customer',
      routeId: 2,
      fromCity: 'دمشق',
      toCity: 'حمص',
      receiverName: 'سارة خالد',
      receiverAddress: 'حي الإنشاءات',
      receiverPhone: '0933112233',
      weight: 1.0,
      cost: 8000.0,
      isPaid: false,
      status: ParcelStatus.inTransit,
      trackingNumber: 'RMA-10002',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ParcelModel(
      id: 3,
      senderId: 1,
      senderType: 'customer',
      routeId: 3,
      fromCity: 'اللاذقية',
      toCity: 'دمشق',
      receiverName: 'ياسين محمود',
      receiverAddress: 'المزة، فيلات شرقية',
      receiverPhone: '0955889900',
      weight: 5.0,
      cost: 25000.0,
      isPaid: true,
      status: ParcelStatus.delivered,
      trackingNumber: 'RMA-10003',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    ParcelModel(
      id: 4,
      senderId: 1,
      senderType: 'customer',
      routeId: 1,
      fromCity: 'حلب',
      toCity: 'دمشق',
      receiverName: 'أحمد المحمد',
      receiverAddress: 'حي الميدان',
      receiverPhone: '0931234567',
      weight: 1.5,
      cost: 7000.0,
      isPaid: true,
      status: ParcelStatus.returned,
      trackingNumber: 'RMA-10004',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  @override
  Future<List<ParcelModel>> getParcels() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockParcels;
  }

  @override
  Future<List<ParcelModel>> getAdminParcels() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockParcels;
  }

  @override
  Future<ParcelModel> updateParcelStatus(int id, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockParcels.indexWhere((p) => p.id == id);
    if (index != -1) {
      // Note: In a real mock we would update the list, but for now we return a copy
      return _mockParcels[index]; 
    }
    throw Exception('Parcel not found');
  }

  @override
  Future<void> confirmParcelReception(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<PaginationModel<ParcelModel>> getReturnedParcels({int? page}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final returnedList = _mockParcels.where((p) => p.status == ParcelStatus.returned).toList();
    return PaginationModel(
      data: returnedList,
      currentPage: 1,
      lastPage: 1,
      total: returnedList.length,
      perPage: 10,
    );
  }

  @override
  Future<ParcelModel> getParcelById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockParcels.firstWhere((p) => p.id == id, orElse: () => _mockParcels.first);
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
    final newParcel = ParcelModel(
      id: _mockParcels.length + 1,
      senderId: 1,
      senderType: 'customer',
      routeId: routeId,
      fromCity: 'دمشق',
      toCity: 'وجهة مجهولة',
      receiverName: receiverName,
      receiverAddress: receiverAddress,
      receiverPhone: receiverPhone,
      weight: weight,
      cost: weight * 5000,
      isPaid: isPaid,
      status: ParcelStatus.pending,
      trackingNumber: 'RMA-${10000 + _mockParcels.length + 1}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return newParcel;
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
    return _mockParcels.firstWhere((p) => p.id == id);
  }

  @override
  Future<void> deleteParcel(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
