import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel.dart';
import '../repositories/parcel_repository.dart';

class CreateParcelUseCase {
  final ParcelRepository repository;

  CreateParcelUseCase(this.repository);

  Future<Either<Failure, Parcel>> call({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  }) async {
    return await repository.createParcel(
      routeId: routeId,
      receiverName: receiverName,
      receiverAddress: receiverAddress,
      receiverPhone: receiverPhone,
      weight: weight,
      isPaid: isPaid,
    );
  }
}
