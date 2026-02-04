import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../parcels/domain/entities/parcel.dart';
import '../repositories/super_admin_repository.dart';

class GetGlobalParcelsUseCase implements UseCase<List<Parcel>, int> {
  final SuperAdminRepository repository;

  GetGlobalParcelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Parcel>>> call(int page) async {
    return await repository.getAllParcels(page);
  }
}
