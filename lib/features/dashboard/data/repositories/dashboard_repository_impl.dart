import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:rma_customer/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rma_customer/features/dashboard/data/datasources/dashboard_remote_datasource.dart';

import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/network/network_info.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getDashboardStats();
        return Right(stats);
      } on ServerException {
        return const Left(ServerFailure('Server Error during dashboard stats fetch'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
