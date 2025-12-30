import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/enums/rating_type.dart';
import '../entities/rating.dart';

abstract class RatingRepository {
  Future<Either<Failure, RatingEntity>> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required double rating,
    String? comment,
  });

  Future<Either<Failure, RatingEntity>> updateRating({
    required int id,
    double? rating,
    String? comment,
  });

  Future<Either<Failure, void>> deleteRating(int id);

  Future<Either<Failure, List<RatingEntity>>> getMyRatings();
}
