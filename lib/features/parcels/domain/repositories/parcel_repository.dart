import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../entities/parcel.dart';

abstract class ParcelRepository {
  Future<Either<Failure, List<Parcel>>> getParcels();
  Future<Either<Failure, List<Parcel>>> getAdminParcels();
  Future<Either<Failure, Parcel>> updateParcelStatus(int id, String status);
  Future<Either<Failure, void>> confirmParcelReception(int id);
  Future<Either<Failure, Pagination<Parcel>>> getReturnedParcels({int? page});
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
