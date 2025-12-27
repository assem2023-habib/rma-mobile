import 'package:equatable/equatable.dart';
import '../../../../core/enums/rating_type.dart';

class RatingEntity extends Equatable {
  final int id;
  final int? rateableId;
  final RatingForType? rateableType;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const RatingEntity({
    required this.id,
    this.rateableId,
    this.rateableType,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, rateableId, rateableType, rating, comment, createdAt];
}
