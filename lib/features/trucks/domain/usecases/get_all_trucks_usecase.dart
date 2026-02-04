import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/truck_entity.dart';
import '../repositories/truck_repository.dart';

class GetAllTrucksUseCase implements UseCase<List<TruckEntity>, NoParams> {
  final TruckRepository repository;

  GetAllTrucksUseCase(this.repository);

  @override
  Future<Either<Failure, List<TruckEntity>>> call(NoParams params) async {
    return await repository.getAllTrucks();
  }
}
