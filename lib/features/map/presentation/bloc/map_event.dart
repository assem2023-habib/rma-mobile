import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class GetParcelLocationEvent extends MapEvent {
  final String parcelId;

  const GetParcelLocationEvent(this.parcelId);

  @override
  List<Object?> get props => [parcelId];
}
