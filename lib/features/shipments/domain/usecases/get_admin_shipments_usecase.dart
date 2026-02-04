import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shipment_entity.dart';
import '../repositories/shipment_repository.dart';

class GetAdminShipmentsUseCase implements UseCase<List<ShipmentEntity>, NoParams> {
  final ShipmentRepository repository;

  GetAdminShipmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ShipmentEntity>>> call(NoParams params) async {
    return await repository.getAdminShipments();
  }
}
