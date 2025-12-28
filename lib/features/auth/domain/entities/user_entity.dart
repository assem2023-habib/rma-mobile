import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? userName;
  final String phone;
  final String? address;
  final String? nationalNumber;
  final String? birthday;
  final int cityId;
  final String? imageProfile;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.userName,
    required this.phone,
    this.address,
    this.nationalNumber,
    this.birthday,
    required this.cityId,
    this.imageProfile,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        userName,
        phone,
        address,
        nationalNumber,
        birthday,
        cityId,
        imageProfile,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
