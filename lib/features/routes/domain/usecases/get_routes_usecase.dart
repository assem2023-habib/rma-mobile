import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/route_entity.dart';
import '../repositories/routes_repository.dart';

class GetRoutesUseCase {
  final RoutesRepository repository;

  GetRoutesUseCase(this.repository);

  Future<Either<Failure, List<RouteEntity>>> call() async {
    return await repository.getRoutes();
  }
}
