import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/rating_repository.dart';

class DeleteRatingUseCase {
  final RatingRepository repository;

  DeleteRatingUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteRating(id);
  }
}
