import '../../../../core/enums/rating_type.dart';
import '../models/rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<RatingModel> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required int rating,
    String? comment,
  });

  Future<RatingModel> updateRating({
    required int id,
    int? rateableId,
    RatingForType? rateableType,
    int? rating,
    String? comment,
  });
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  @override
  Future<RatingModel> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required int rating,
    String? comment,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return RatingModel(
      id: 1,
      rateableId: rateableId,
      rateableType: rateableType,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<RatingModel> updateRating({
    required int id,
    int? rateableId,
    RatingForType? rateableType,
    int? rating,
    String? comment,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return RatingModel(
      id: id,
      rateableId: rateableId,
      rateableType: rateableType,
      rating: rating ?? 5,
      comment: comment,
      createdAt: DateTime.now(),
    );
  }
}
