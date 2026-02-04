import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.userName,
    required super.phone,
    super.userType,
    super.address,
    super.nationalNumber,
    super.birthday,
    required super.cityId,
    super.imageProfile,
    super.emailVerifiedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      userName: json['user_name'],
      phone: json['phone'] ?? '',
      userType: json['user_type'],
      address: json['address'],
      nationalNumber: json['national_number'],
      birthday: json['birthday'],
      cityId: json['city_id'] ?? 0,
      imageProfile: json['image_profile'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_name': userName,
      'phone': phone,
      'user_type': userType,
      'address': address,
      'national_number': nationalNumber,
      'birthday': birthday,
      'city_id': cityId,
      'image_profile': imageProfile,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
