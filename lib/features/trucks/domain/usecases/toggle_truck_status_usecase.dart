import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/truck_entity.dart';
import '../repositories/truck_repository.dart';

class ToggleTruckStatusUseCase implements UseCase<TruckEntity, int> {
  final TruckRepository repository;

  ToggleTruckStatusUseCase(this.repository);

  @override
  Future<Either<Failure, TruckEntity>> call(int id) async {
    return await repository.toggleTruckStatus(id);
  }
}
