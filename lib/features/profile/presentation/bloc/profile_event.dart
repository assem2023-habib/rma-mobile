import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String? email;
  final String? userName;
  final String phone;
  final String? birthday;
  final int cityId;
  final String? nationalNumber;
  final String? address;
  final dynamic imageProfile;

  const UpdateProfileRequested({
    required this.firstName,
    required this.lastName,
    this.email,
    this.userName,
    required this.phone,
    this.birthday,
    required this.cityId,
    this.nationalNumber,
    this.address,
    this.imageProfile,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        userName,
        phone,
        birthday,
        cityId,
        nationalNumber,
        address,
        imageProfile,
      ];
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
