import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Either<Failure, DashboardStats>> call() async {
    return await repository.getDashboardStats();
  }
}
