import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/new_parcel.dart';
import '../repositories/new_parcel_repository.dart';

class CreateParcelUseCase {
  final NewParcelRepository repository;

  CreateParcelUseCase(this.repository);

  Future<Either<Failure, Unit>> call(NewParcel parcel) async {
    return await repository.createParcel(parcel);
  }
}
