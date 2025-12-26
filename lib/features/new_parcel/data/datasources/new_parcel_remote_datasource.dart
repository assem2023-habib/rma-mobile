import 'package:dartz/dartz.dart';
import '../models/new_parcel_model.dart';

abstract class NewParcelRemoteDataSource {
  Future<Unit> createParcel(NewParcelModel parcelModel);
}

class NewParcelRemoteDataSourceImpl implements NewParcelRemoteDataSource {
  @override
  Future<Unit> createParcel(NewParcelModel parcelModel) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would be a Dio call
    // await dio.post('/parcels', data: parcelModel.toJson());
    
    return unit;
  }
}
