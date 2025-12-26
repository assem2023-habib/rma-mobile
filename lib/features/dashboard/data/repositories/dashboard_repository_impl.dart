import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:rma_customer/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rma_customer/features/dashboard/data/datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    try {
      final stats = await remoteDataSource.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
