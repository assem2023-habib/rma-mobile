import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/shipment_remote_datasource.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../../domain/entities/shipment_entity.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ShipmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ShipmentEntity>>> getAdminShipments() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAdminShipments();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> departShipment(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.departShipment(id);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> arriveShipment(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.arriveShipment(id);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
