import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class NewPasswordSuccess extends AuthState {
  final String message;

  const NewPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class VerifyEmailSuccess extends AuthState {
  final String message;

  const VerifyEmailSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ConfirmEmailOtpSuccess extends AuthState {
  final String message;

  const ConfirmEmailOtpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class TelegramOtpSent extends AuthState {
  final String message;
  const TelegramOtpSent({required this.message});
  @override
  List<Object?> get props => [message];
}

class TelegramOtpVerified extends AuthState {
  final String message;
  const TelegramOtpVerified({required this.message});
  @override
  List<Object?> get props => [message];
}
