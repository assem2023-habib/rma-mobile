import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/core/network/network_info.dart';
import 'package:rma_customer/features/map/domain/entities/parcel_location.dart';
import 'package:rma_customer/features/map/domain/repositories/map_repository.dart';
import 'package:rma_customer/features/map/data/datasources/map_remote_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MapRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ParcelLocation>> getParcelLocation(
      String parcelId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getParcelLocation(parcelId);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء جلب موقع الطرد'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
