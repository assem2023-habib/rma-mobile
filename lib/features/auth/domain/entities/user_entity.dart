import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? userName;
  final String phone;
  final int cityId;
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
    required this.cityId,
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
        cityId,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
