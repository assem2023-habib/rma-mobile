import 'package:equatable/equatable.dart';
import '../../domain/entities/truck_entity.dart';

abstract class TrucksState extends Equatable {
  const TrucksState();

  @override
  List<Object?> get props => [];
}

class TrucksInitial extends TrucksState {}

class TrucksLoading extends TrucksState {}

class TrucksLoaded extends TrucksState {
  final List<TruckEntity> trucks;

  const TrucksLoaded(this.trucks);

  @override
  List<Object?> get props => [trucks];
}

class TruckStatusToggled extends TrucksState {
  final TruckEntity truck;

  const TruckStatusToggled(this.truck);

  @override
  List<Object?> get props => [truck];
}

class TrucksError extends TrucksState {
  final String message;

  const TrucksError(this.message);

  @override
  List<Object?> get props => [message];
}
