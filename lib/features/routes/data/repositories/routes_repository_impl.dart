import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/features/routes/domain/entities/route_entity.dart';
import 'package:rma_customer/features/routes/domain/repositories/routes_repository.dart';
import 'package:rma_customer/features/routes/data/datasources/routes_remote_datasource.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RoutesRemoteDataSource remoteDataSource;

  RoutesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RouteEntity>>> getRoutes() async {
    try {
      final remoteRoutes = await remoteDataSource.getRoutes();
      return Right(remoteRoutes);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
