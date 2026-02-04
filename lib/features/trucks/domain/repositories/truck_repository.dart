import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/truck_entity.dart';

abstract class TruckRepository {
  Future<Either<Failure, List<TruckEntity>>> getAllTrucks();
  Future<Either<Failure, TruckEntity>> getTruckDetails(int id);
  Future<Either<Failure, TruckEntity>> toggleTruckStatus(int id);
}
