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
  final String? authorizedFirstName;
  final String? authorizedLastName;
  final String? authorizedPhone;
  final String? authorizedNationalNumber;
  final String? authorizedAddress;
  final int? authorizedCityId;
  final String? authorizedBirthday;

  const CreateAuthorizationEvent({
    required this.parcelId,
    required this.authorizedUserType,
    this.authorizedUserId,
    this.authorizedFirstName,
    this.authorizedLastName,
    this.authorizedPhone,
    this.authorizedNationalNumber,
    this.authorizedAddress,
    this.authorizedCityId,
    this.authorizedBirthday,
  });

  @override
  List<Object?> get props => [
    parcelId,
    authorizedUserType,
    authorizedUserId,
    authorizedFirstName,
    authorizedLastName,
    authorizedPhone,
    authorizedNationalNumber,
    authorizedAddress,
    authorizedCityId,
    authorizedBirthday,
  ];
}

class CancelAuthorizationEvent extends AuthorizationsEvent {
  final int id;

  const CancelAuthorizationEvent(this.id);

  @override
  List<Object?> get props => [id];
}
