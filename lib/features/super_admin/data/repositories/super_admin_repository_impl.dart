import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../parcels/domain/entities/parcel.dart';
import '../../domain/entities/super_admin_stats_entity.dart';
import '../../domain/repositories/super_admin_repository.dart';
import '../datasources/super_admin_remote_datasource.dart';

class SuperAdminRepositoryImpl implements SuperAdminRepository {
  final SuperAdminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SuperAdminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SuperAdminStatsEntity>> getSuperAdminStats() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteStats = await remoteDataSource.getSuperAdminStats();
        return Right(remoteStats);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, List<Parcel>>> getAllParcels(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteParcels = await remoteDataSource.getAllParcels(page);
        return Right(remoteParcels);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
