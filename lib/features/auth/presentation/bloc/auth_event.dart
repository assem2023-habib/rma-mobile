import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String birthday;
  final int cityId;
  final String nationalNumber;

  const RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.birthday,
    required this.cityId,
    required this.nationalNumber,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        passwordConfirmation,
        phone,
        birthday,
        cityId,
        nationalNumber,
      ];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class NewPasswordRequested extends AuthEvent {
  final String email;
  final String otpCode;
  final String newPassword;
  final String newPasswordConfirmation;

  const NewPasswordRequested({
    required this.email,
    required this.otpCode,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  @override
  List<Object?> get props => [email, otpCode, newPassword, newPasswordConfirmation];
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const VerifyEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class ConfirmEmailOtpRequested extends AuthEvent {
  final String email;
  final String otpCode;

  const ConfirmEmailOtpRequested({required this.email, required this.otpCode});

  @override
  List<Object?> get props => [email, otpCode];
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
