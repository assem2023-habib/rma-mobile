import '../../../../core/api/api_config.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/enums/rating_type.dart';
import '../../../../core/error/exceptions.dart';
import '../models/rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<RatingModel> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required double rating,
    String? comment,
  });

  Future<RatingModel> updateRating({
    required int id,
    double? rating,
    String? comment,
  });

  Future<void> deleteRating(int id);

  Future<List<RatingModel>> getMyRatings();
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final DioClient dioClient;

  RatingRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RatingModel> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required double rating,
    String? comment,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConfig.rates,
        data: {
          if (rateableId != null) 'rateable_id': rateableId,
          if (rateableType != null) 'rateable_type': rateableType.value,
          'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RatingModel.fromJson(response.data['data']['rate']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<RatingModel> updateRating({
    required int id,
    double? rating,
    String? comment,
  }) async {
    try {
      final response = await dioClient.put(
        '${ApiConfig.rates}/$id',
        data: {
          if (rating != null) 'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );
      if (response.statusCode == 200) {
        return RatingModel.fromJson(response.data['data']['rate']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteRating(int id) async {
    try {
      final response = await dioClient.delete('${ApiConfig.rates}/$id');
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<RatingModel>> getMyRatings() async {
    try {
      final response = await dioClient.get(ApiConfig.rates);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['rates'];
        return data.map((json) => RatingModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
