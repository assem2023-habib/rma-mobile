import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/rating_type.dart';
import '../../domain/entities/rating.dart';
import '../../domain/usecases/create_rating_usecase.dart';

// Events
abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object?> get props => [];
}

class CreateRatingRequested extends RatingEvent {
  final int? rateableId;
  final RatingForType? rateableType;
  final int rating;
  final String? comment;

  const CreateRatingRequested({
    this.rateableId,
    this.rateableType,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [rateableId, rateableType, rating, comment];
}

// States
abstract class RatingState extends Equatable {
  const RatingState();
  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}
class RatingLoading extends RatingState {}
class RatingSuccess extends RatingState {
  final RatingEntity rating;
  const RatingSuccess(this.rating);
  @override
  List<Object?> get props => [rating];
}
class RatingError extends RatingState {
  final String message;
  const RatingError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final CreateRatingUseCase createRatingUseCase;

  RatingBloc({required this.createRatingUseCase}) : super(RatingInitial()) {
    on<CreateRatingRequested>(_onCreateRatingRequested);
  }

  Future<void> _onCreateRatingRequested(
    CreateRatingRequested event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    final result = await createRatingUseCase(
      rateableId: event.rateableId,
      rateableType: event.rateableType,
      rating: event.rating,
      comment: event.comment,
    );

    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (rating) => emit(RatingSuccess(rating)),
    );
  }
}
