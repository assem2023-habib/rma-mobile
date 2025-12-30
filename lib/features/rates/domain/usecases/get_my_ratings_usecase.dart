import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class GetMyRatingsUseCase {
  final RatingRepository repository;

  GetMyRatingsUseCase(this.repository);

  Future<Either<Failure, List<RatingEntity>>> call() {
    return repository.getMyRatings();
  }
}
