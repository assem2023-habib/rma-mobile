import 'package:equatable/equatable.dart';

abstract class CommonEvent extends Equatable {
  const CommonEvent();

  @override
  List<Object?> get props => [];
}

class GetCountriesRequested extends CommonEvent {}

class GetCitiesRequested extends CommonEvent {
  final int countryId;
  const GetCitiesRequested(this.countryId);

  @override
  List<Object?> get props => [countryId];
}
