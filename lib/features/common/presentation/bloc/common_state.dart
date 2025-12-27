import 'package:equatable/equatable.dart';

abstract class CommonState extends Equatable {
  const CommonState();

  @override
  List<Object?> get props => [];
}

class CommonInitial extends CommonState {}

class CommonLoading extends CommonState {}

class CountriesLoaded extends CommonState {
  final List<dynamic> countries;
  const CountriesLoaded(this.countries);

  @override
  List<Object?> get props => [countries];
}

class CitiesLoaded extends CommonState {
  final List<dynamic> cities;
  const CitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CommonError extends CommonState {
  final String message;
  const CommonError(this.message);

  @override
  List<Object?> get props => [message];
}
