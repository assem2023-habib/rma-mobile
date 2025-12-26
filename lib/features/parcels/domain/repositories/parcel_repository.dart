import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel.dart';

abstract class ParcelRepository {
  Future<Either<Failure, List<Parcel>>> getParcels();
  Future<Either<Failure, Parcel>> getParcelById(String id);
}
