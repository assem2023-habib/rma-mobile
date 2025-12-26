import 'package:equatable/equatable.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserEntity user;

  const ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class PasswordChanged extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
