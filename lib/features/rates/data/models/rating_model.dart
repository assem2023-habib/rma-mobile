import '../../../../core/enums/rating_type.dart';
import '../../domain/entities/rating.dart';

class RatingModel extends RatingEntity {
  const RatingModel({
    required super.id,
    super.rateableId,
    super.rateableType,
    required super.rating,
    super.comment,
    required super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rateableId: json['rateable_id'],
      rateableType: json['rateable_type'] != null 
          ? RatingForType.fromString(json['rateable_type']) 
          : null,
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (rateableId != null) 'rateable_id': rateableId,
      if (rateableType != null) 'rateable_type': rateableType!.value,
      'rating': rating,
      if (comment != null) 'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
