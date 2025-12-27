import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/parcels/domain/entities/parcel.dart';
import 'package:rma_customer/features/parcels/domain/repositories/parcel_repository.dart';
import 'package:rma_customer/features/parcels/data/datasources/parcel_remote_datasource.dart';

import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/network/network_info.dart';

class ParcelRepositoryImpl implements ParcelRepository {
  final ParcelRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ParcelRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Parcel>>> getParcels() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteParcels = await remoteDataSource.getParcels();
        return Right(remoteParcels);
      } on ServerException {
        return const Left(ServerFailure('فشل تحميل الطرود من الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, Parcel>> getParcelById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteParcel = await remoteDataSource.getParcelById(id);
        return Right(remoteParcel);
      } on ServerException {
        return const Left(ServerFailure('فشل تحميل تفاصيل الطرد من الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
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
    if (await networkInfo.isConnected) {
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
      } on ServerException {
        return const Left(ServerFailure('فشل إنشاء الطرد في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
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
    if (await networkInfo.isConnected) {
      try {
        final remoteParcel = await remoteDataSource.updateParcel(
          id: id,
          receiverName: receiverName,
          receiverAddress: receiverAddress,
          receiverPhone: receiverPhone,
          weight: weight,
        );
        return Right(remoteParcel);
      } on ServerException {
        return const Left(ServerFailure('فشل تحديث الطرد في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteParcel(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteParcel(id);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure('فشل حذف الطرد في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
