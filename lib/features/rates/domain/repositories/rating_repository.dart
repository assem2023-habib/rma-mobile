import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/enums/rating_type.dart';
import '../entities/rating.dart';

abstract class RatingRepository {
  Future<Either<Failure, RatingEntity>> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required int rating,
    String? comment,
  });

  Future<Either<Failure, RatingEntity>> updateRating({
    required int id,
    int? rateableId,
    RatingForType? rateableType,
    int? rating,
    String? comment,
  });
}
