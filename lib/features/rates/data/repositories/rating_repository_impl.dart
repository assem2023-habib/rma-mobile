import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/enums/rating_type.dart';
import '../../domain/entities/rating.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_datasource.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RatingEntity>> createRating({
    int? rateableId,
    RatingForType? rateableType,
    required int rating,
    String? comment,
  }) async {
    try {
      final result = await remoteDataSource.createRating(
        rateableId: rateableId,
        rateableType: rateableType,
        rating: rating,
        comment: comment,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingEntity>> updateRating({
    required int id,
    int? rateableId,
    RatingForType? rateableType,
    int? rating,
    String? comment,
  }) async {
    try {
      final result = await remoteDataSource.updateRating(
        id: id,
        rateableId: rateableId,
        rateableType: rateableType,
        rating: rating,
        comment: comment,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
