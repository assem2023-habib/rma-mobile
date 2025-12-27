import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/parcel_repository.dart';

class DeleteParcelUseCase {
  final ParcelRepository repository;

  DeleteParcelUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteParcel(id);
  }
}
