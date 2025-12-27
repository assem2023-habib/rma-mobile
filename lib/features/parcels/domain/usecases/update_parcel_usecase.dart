import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class UpdateParcelUseCase {
  final ParcelRepository repository;

  UpdateParcelUseCase(this.repository);

  Future<Either<Failure, Parcel>> call({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  }) async {
    return await repository.updateParcel(
      id: id,
      receiverName: receiverName,
      receiverAddress: receiverAddress,
      receiverPhone: receiverPhone,
      weight: weight,
    );
  }
}
