import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class GetParcelByIdUseCase {
  final ParcelRepository repository;

  GetParcelByIdUseCase(this.repository);

  Future<Either<Failure, Parcel>> call(int id) async {
    return await repository.getParcelById(id);
  }
}
