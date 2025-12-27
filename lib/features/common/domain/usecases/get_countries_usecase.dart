import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/common_repository.dart';

class GetCountriesUseCase {
  final CommonRepository repository;

  GetCountriesUseCase(this.repository);

  Future<Either<Failure, List<dynamic>>> call() async {
    return await repository.getCountries();
  }
}
