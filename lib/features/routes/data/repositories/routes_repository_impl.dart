import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/core/network/network_info.dart';
import 'package:rma_customer/features/routes/domain/entities/route_entity.dart';
import 'package:rma_customer/features/routes/domain/repositories/routes_repository.dart';
import 'package:rma_customer/features/routes/data/datasources/routes_remote_datasource.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RoutesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RoutesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RouteEntity>>> getRoutes() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRoutes = await remoteDataSource.getRoutes();
        return Right(remoteRoutes);
      } on ServerException {
        return const Left(ServerFailure('فشل تحميل المسارات من الخادم'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }
}
