import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel.dart';

abstract class ParcelRepository {
  Future<Either<Failure, List<Parcel>>> getParcels();
  Future<Either<Failure, Parcel>> getParcelById(int id);
  Future<Either<Failure, Parcel>> createParcel({
    required int routeId,
    required String receiverName,
    required String receiverAddress,
    required String receiverPhone,
    required double weight,
    required bool isPaid,
  });
  Future<Either<Failure, Parcel>> updateParcel({
    required int id,
    String? receiverName,
    String? receiverAddress,
    String? receiverPhone,
    double? weight,
  });
  Future<Either<Failure, void>> deleteParcel(int id);
}
