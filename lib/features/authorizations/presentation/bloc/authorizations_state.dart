import 'package:equatable/equatable.dart';
import '../../domain/entities/authorization_entity.dart';

abstract class AuthorizationsState extends Equatable {
  const AuthorizationsState();

  @override
  List<Object?> get props => [];
}

class AuthorizationsInitial extends AuthorizationsState {}

class AuthorizationsLoading extends AuthorizationsState {}

class AuthorizationsLoaded extends AuthorizationsState {
  final List<AuthorizationEntity> authorizations;

  const AuthorizationsLoaded(this.authorizations);

  @override
  List<Object?> get props => [authorizations];
}

class AuthorizationDetailLoaded extends AuthorizationsState {
  final AuthorizationEntity authorization;

  const AuthorizationDetailLoaded(this.authorization);

  @override
  List<Object?> get props => [authorization];
}

class AuthorizationActionInProgress extends AuthorizationsState {}

class AuthorizationActionSuccess extends AuthorizationsState {
  final String message;

  const AuthorizationActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthorizationsError extends AuthorizationsState {
  final String message;

  const AuthorizationsError(this.message);

  @override
  List<Object?> get props => [message];
}
