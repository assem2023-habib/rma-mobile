import 'package:equatable/equatable.dart';

abstract class AuthorizationsEvent extends Equatable {
  const AuthorizationsEvent();

  @override
  List<Object?> get props => [];
}

class GetAuthorizationsEvent extends AuthorizationsEvent {}

class GetAuthorizationByIdEvent extends AuthorizationsEvent {
  final int id;

  const GetAuthorizationByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateAuthorizationEvent extends AuthorizationsEvent {
  final int parcelId;
  final String authorizedUserType;
  final int? authorizedUserId;

  const CreateAuthorizationEvent({
    required this.parcelId,
    required this.authorizedUserType,
    this.authorizedUserId,
  });

  @override
  List<Object?> get props => [parcelId, authorizedUserType, authorizedUserId];
}

class CancelAuthorizationEvent extends AuthorizationsEvent {
  final int id;

  const CancelAuthorizationEvent(this.id);

  @override
  List<Object?> get props => [id];
}
