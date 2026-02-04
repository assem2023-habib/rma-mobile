import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class UpdateParcelStatusUseCase implements UseCase<Parcel, UpdateParcelStatusParams> {
  final ParcelRepository repository;

  UpdateParcelStatusUseCase(this.repository);

  @override
  Future<Either<Failure, Parcel>> call(UpdateParcelStatusParams params) async {
    return await repository.updateParcelStatus(params.id, params.status);
  }
}

class UpdateParcelStatusParams {
  final int id;
  final String status;

  UpdateParcelStatusParams({required this.id, required this.status});
}
