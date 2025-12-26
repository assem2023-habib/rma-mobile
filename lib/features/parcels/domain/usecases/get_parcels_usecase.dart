import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class GetParcelsUseCase {
  final ParcelRepository repository;

  GetParcelsUseCase(this.repository);

  Future<Either<Failure, List<Parcel>>> call() async {
    return await repository.getParcels();
  }
}
