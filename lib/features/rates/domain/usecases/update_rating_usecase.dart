import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class UpdateRatingUseCase {
  final RatingRepository repository;

  UpdateRatingUseCase(this.repository);

  Future<Either<Failure, RatingEntity>> call({
    required int id,
    double? rating,
    String? comment,
  }) {
    return repository.updateRating(
      id: id,
      rating: rating,
      comment: comment,
    );
  }
}
