import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/parcel_repository.dart';

class ConfirmParcelReceptionUseCase implements UseCase<void, int> {
  final ParcelRepository repository;

  ConfirmParcelReceptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await repository.confirmParcelReception(id);
  }
}
