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
  Future<Either<Failure, Parcel>> getParcelById(int id) async {
    try {
      final remoteParcel = await remoteDataSource.getParcelById(id);
      return Right(remoteParcel);
    } catch (e) {
      return const Left(ServerFailure('فشل تحميل تفاصيل الطرد'));
    }
  }

  @override
  Future<Either<Failure, Parcel>> createParcel({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  }) async {
    try {
      final remoteParcel = await remoteDataSource.createParcel(
        routeId: routeId,
        receiverName: receiverName,
        receiverAddress: receiverAddress,
        receiverPhone: receiverPhone,
        weight: weight,
        isPaid: isPaid,
      );
      return Right(remoteParcel);
    } catch (e) {
      return const Left(ServerFailure('فشل إنشاء الطرد'));
    }
  }

  @override
  Future<Either<Failure, Parcel>> updateParcel({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  }) async {
    try {
      final remoteParcel = await remoteDataSource.updateParcel(
        id: id,
        receiverName: receiverName,
        receiverAddress: receiverAddress,
        receiverPhone: receiverPhone,
        weight: weight,
      );
      return Right(remoteParcel);
    } catch (e) {
      return const Left(ServerFailure('فشل تحديث الطرد'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteParcel(int id) async {
    try {
      await remoteDataSource.deleteParcel(id);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('فشل حذف الطرد'));
    }
  }
}
