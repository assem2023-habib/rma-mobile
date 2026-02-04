import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class GetAdminParcelsUseCase implements UseCase<List<Parcel>, NoParams> {
  final ParcelRepository repository;

  GetAdminParcelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Parcel>>> call(NoParams params) async {
    return await repository.getAdminParcels();
  }
}
