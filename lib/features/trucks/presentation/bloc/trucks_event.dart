import 'package:equatable/equatable.dart';

abstract class TrucksEvent extends Equatable {
  const TrucksEvent();

  @override
  List<Object?> get props => [];
}

class GetAllTrucksEvent extends TrucksEvent {}

class ToggleTruckStatusEvent extends TrucksEvent {
  final int id;

  const ToggleTruckStatusEvent(this.id);

  @override
  List<Object?> get props => [id];
}
