import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/common_repository.dart';

class GetCitiesUseCase {
  final CommonRepository repository;

  GetCitiesUseCase(this.repository);

  Future<Either<Failure, List<dynamic>>> call(int countryId) async {
    return await repository.getCities(countryId);
  }
}
