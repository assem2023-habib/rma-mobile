import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/parcels/domain/entities/parcel.dart';
import 'package:rma_customer/features/parcels/domain/repositories/parcel_repository.dart';
import 'package:rma_customer/features/parcels/data/datasources/parcel_remote_datasource.dart';

class ParcelRepositoryImpl implements ParcelRepository {
  final ParcelRemoteDataSource remoteDataSource;

  ParcelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Parcel>>> getParcels() async {
    try {
      final remoteParcels = await remoteDataSource.getParcels();
      return Right(remoteParcels);
    } catch (e) {
      return const Left(ServerFailure('فشل تحميل الطرود'));
    }
  }

  @override
  Future<Either<Failure, Parcel>> getParcelById(String id) async {
    try {
      final remoteParcel = await remoteDataSource.getParcelById(id);
      return Right(remoteParcel);
    } catch (e) {
      return const Left(ServerFailure('فشل تحميل تفاصيل الطرد'));
    }
  }
}
