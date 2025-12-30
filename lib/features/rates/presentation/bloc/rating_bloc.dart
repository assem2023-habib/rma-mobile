import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/enums/rating_type.dart';
import '../../domain/entities/rating.dart';
import '../../domain/usecases/create_rating_usecase.dart';
import '../../domain/usecases/update_rating_usecase.dart';
import '../../domain/usecases/delete_rating_usecase.dart';
import '../../domain/usecases/get_my_ratings_usecase.dart';

// Events
abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object?> get props => [];
}

class CreateRatingRequested extends RatingEvent {
  final int? rateableId;
  final RatingForType? rateableType;
  final double rating;
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

class UpdateRatingRequested extends RatingEvent {
  final int id;
  final double? rating;
  final String? comment;

  const UpdateRatingRequested({
    required this.id,
    this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [id, rating, comment];
}

class DeleteRatingRequested extends RatingEvent {
  final int id;
  const DeleteRatingRequested(this.id);
  @override
  List<Object?> get props => [id];
}

class GetMyRatingsRequested extends RatingEvent {}

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

class RatingsLoaded extends RatingState {
  final List<RatingEntity> ratings;
  const RatingsLoaded(this.ratings);
  @override
  List<Object?> get props => [ratings];
}

class RatingDeleted extends RatingState {}

class RatingError extends RatingState {
  final String message;
  const RatingError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final CreateRatingUseCase createRatingUseCase;
  final UpdateRatingUseCase updateRatingUseCase;
  final DeleteRatingUseCase deleteRatingUseCase;
  final GetMyRatingsUseCase getMyRatingsUseCase;

  RatingBloc({
    required this.createRatingUseCase,
    required this.updateRatingUseCase,
    required this.deleteRatingUseCase,
    required this.getMyRatingsUseCase,
  }) : super(RatingInitial()) {
    on<CreateRatingRequested>(_onCreateRatingRequested);
    on<UpdateRatingRequested>(_onUpdateRatingRequested);
    on<DeleteRatingRequested>(_onDeleteRatingRequested);
    on<GetMyRatingsRequested>(_onGetMyRatingsRequested);
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

  Future<void> _onUpdateRatingRequested(
    UpdateRatingRequested event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    final result = await updateRatingUseCase(
      id: event.id,
      rating: event.rating,
      comment: event.comment,
    );

    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (rating) => emit(RatingSuccess(rating)),
    );
  }

  Future<void> _onDeleteRatingRequested(
    DeleteRatingRequested event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    final result = await deleteRatingUseCase(event.id);

    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (_) => emit(RatingDeleted()),
    );
  }

  Future<void> _onGetMyRatingsRequested(
    GetMyRatingsRequested event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    final result = await getMyRatingsUseCase();

    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (ratings) => emit(RatingsLoaded(ratings)),
    );
  }
}
