import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/super_admin_stats_entity.dart';
import '../repositories/super_admin_repository.dart';

class GetSuperAdminStatsUseCase implements UseCase<SuperAdminStatsEntity, NoParams> {
  final SuperAdminRepository repository;

  GetSuperAdminStatsUseCase(this.repository);

  @override
  Future<Either<Failure, SuperAdminStatsEntity>> call(NoParams params) async {
    return await repository.getSuperAdminStats();
  }
}
