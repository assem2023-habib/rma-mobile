import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/map/domain/entities/parcel_location.dart';
import 'package:rma_customer/features/map/domain/repositories/map_repository.dart';
import 'package:rma_customer/features/map/data/datasources/map_remote_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ParcelLocation>> getParcelLocation(String parcelId) async {
    try {
      final remoteData = await remoteDataSource.getParcelLocation(parcelId);
      return Right(remoteData);
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ أثناء جلب موقع الطرد'));
    }
  }
}
