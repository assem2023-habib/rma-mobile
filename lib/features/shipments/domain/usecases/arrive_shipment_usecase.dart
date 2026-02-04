import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/shipment_repository.dart';

class ArriveShipmentUseCase implements UseCase<void, int> {
  final ShipmentRepository repository;

  ArriveShipmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await repository.arriveShipment(id);
  }
}
