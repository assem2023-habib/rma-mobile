import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class GetReturnedParcelsUseCase {
  final ParcelRepository repository;

  GetReturnedParcelsUseCase(this.repository);

  Future<Either<Failure, Pagination<Parcel>>> call({int? page}) async {
    return await repository.getReturnedParcels(page: page);
  }
}
