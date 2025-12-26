import 'package:equatable/equatable.dart';
import '../../domain/entities/authorization_entity.dart';

abstract class AuthorizationsEvent extends Equatable {
  const AuthorizationsEvent();

  @override
  List<Object?> get props => [];
}

class GetAuthorizationsEvent extends AuthorizationsEvent {}

class RequestAuthorizationEvent extends AuthorizationsEvent {
  final AuthorizationEntity authorization;

  const RequestAuthorizationEvent(this.authorization);

  @override
  List<Object?> get props => [authorization];
}
