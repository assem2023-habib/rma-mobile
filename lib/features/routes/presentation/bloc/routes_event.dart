import 'package:equatable/equatable.dart';

abstract class RoutesEvent extends Equatable {
  const RoutesEvent();

  @override
  List<Object> get props => [];
}

class GetRoutesEvent extends RoutesEvent {}
