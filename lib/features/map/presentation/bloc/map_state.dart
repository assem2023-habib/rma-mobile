import 'package:equatable/equatable.dart';
import '../../domain/entities/parcel_location.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final ParcelLocation parcelLocation;

  const MapLoaded(this.parcelLocation);

  @override
  List<Object?> get props => [parcelLocation];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
