import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/truck_entity.dart';
import '../../domain/repositories/truck_repository.dart';
import '../datasources/truck_remote_datasource.dart';

class TruckRepositoryImpl implements TruckRepository {
  final TruckRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TruckRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TruckEntity>>> getAllTrucks() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrucks = await remoteDataSource.getAllTrucks();
        return Right(remoteTrucks);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, TruckEntity>> getTruckDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTruck = await remoteDataSource.getTruckDetails(id);
        return Right(remoteTruck);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, TruckEntity>> toggleTruckStatus(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTruck = await remoteDataSource.toggleTruckStatus(id);
        return Right(remoteTruck);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
