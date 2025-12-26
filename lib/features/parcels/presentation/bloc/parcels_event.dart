import 'package:equatable/equatable.dart';

abstract class ParcelsEvent extends Equatable {
  const ParcelsEvent();

  @override
  List<Object> get props => [];
}

class GetParcelsEvent extends ParcelsEvent {}

class SearchParcelsEvent extends ParcelsEvent {
  final String query;
  const SearchParcelsEvent(this.query);

  @override
  List<Object> get props => [query];
}
