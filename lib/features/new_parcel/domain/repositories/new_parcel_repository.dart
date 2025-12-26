import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/new_parcel.dart';

abstract class NewParcelRepository {
  Future<Either<Failure, Unit>> createParcel(NewParcel parcel);
}
