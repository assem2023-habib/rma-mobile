import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shipment_entity.dart';

abstract class ShipmentRepository {
  Future<Either<Failure, List<ShipmentEntity>>> getAdminShipments();
  Future<Either<Failure, void>> departShipment(int id);
  Future<Either<Failure, void>> arriveShipment(int id);
}
