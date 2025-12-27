import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final int cityId;

  const UpdateProfileRequested({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.cityId,
  });

  @override
  List<Object?> get props => [firstName, lastName, phone, cityId];
}

class ChangePasswordRequested extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
