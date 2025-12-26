import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/parcel_location.dart';

abstract class MapRepository {
  Future<Either<Failure, ParcelLocation>> getParcelLocation(String parcelId);
}
