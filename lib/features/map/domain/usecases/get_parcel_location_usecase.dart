import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel_location.dart';
import '../repositories/map_repository.dart';

class GetParcelLocationUseCase {
  final MapRepository repository;

  GetParcelLocationUseCase(this.repository);

  Future<Either<Failure, ParcelLocation>> call(String parcelId) async {
    return await repository.getParcelLocation(parcelId);
  }
}
