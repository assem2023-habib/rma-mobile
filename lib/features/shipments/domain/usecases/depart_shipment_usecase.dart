import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/shipment_repository.dart';

class DepartShipmentUseCase implements UseCase<void, int> {
  final ShipmentRepository repository;

  DepartShipmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await repository.departShipment(id);
  }
}
