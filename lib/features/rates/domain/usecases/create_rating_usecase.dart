import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/enums/rating_type.dart';
import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class CreateRatingUseCase {
  final RatingRepository repository;

  CreateRatingUseCase(this.repository);

  Future<Either<Failure, RatingEntity>> call({
    int? rateableId,
    RatingForType? rateableType,
    required int rating,
    String? comment,
  }) {
    return repository.createRating(
      rateableId: rateableId,
      rateableType: rateableType,
      rating: rating,
      comment: comment,
    );
  }
}
