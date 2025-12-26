import '../models/parcel_location_model.dart';

abstract class MapRemoteDataSource {
  Future<ParcelLocationModel> getParcelLocation(String parcelId);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  @override
  Future<ParcelLocationModel> getParcelLocation(String parcelId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return ParcelLocationModel(
      parcelId: parcelId,
      latitude: 33.3152, // Baghdad
      longitude: 44.3661,
      status: 'في الطريق',
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }
}
