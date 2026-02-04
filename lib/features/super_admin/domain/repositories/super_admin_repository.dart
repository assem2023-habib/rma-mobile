import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/super_admin_stats_entity.dart';
import '../../../parcels/domain/entities/parcel.dart';

abstract class SuperAdminRepository {
  Future<Either<Failure, SuperAdminStatsEntity>> getSuperAdminStats();
  Future<Either<Failure, List<Parcel>>> getAllParcels(int page);
}
