import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;

  const UpdateProfileRequested({
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [name, phoneNumber, profileImageUrl];
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
