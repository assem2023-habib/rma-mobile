import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/route_entity.dart';

abstract class RoutesRepository {
  Future<Either<Failure, List<RouteEntity>>> getRoutes();
}
