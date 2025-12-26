import 'package:equatable/equatable.dart';
import '../../domain/entities/route_entity.dart';

abstract class RoutesState extends Equatable {
  const RoutesState();

  @override
  List<Object> get props => [];
}

class RoutesInitial extends RoutesState {}

class RoutesLoading extends RoutesState {}

class RoutesLoaded extends RoutesState {
  final List<RouteEntity> routes;

  const RoutesLoaded(this.routes);

  @override
  List<Object> get props => [routes];
}

class RoutesError extends RoutesState {
  final String message;

  const RoutesError(this.message);

  @override
  List<Object> get props => [message];
}
