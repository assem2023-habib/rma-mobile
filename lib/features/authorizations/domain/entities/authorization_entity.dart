import 'package:equatable/equatable.dart';

class AuthorizationEntity extends Equatable {
  final int id;
  final int userId;
  final int parcelId;
  final int? authorizedUserId;
  final String authorizedUserType;
  final String authorizedCode;
  final String status;
  final DateTime generatedAt;
  final DateTime expiredAt;
  final DateTime? usedAt;
  final String? cancellationReason;
  final AuthorizationParcelInfo? parcel;
  final AuthorizedUserInfo? authorizedUser;

  const AuthorizationEntity({
    required this.id,
    required this.userId,
    required this.parcelId,
    this.authorizedUserId,
    required this.authorizedUserType,
    required this.authorizedCode,
    required this.status,
    required this.generatedAt,
    required this.expiredAt,
    this.usedAt,
    this.cancellationReason,
    this.parcel,
    this.authorizedUser,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        parcelId,
        authorizedUserId,
        authorizedUserType,
        authorizedCode,
        status,
        generatedAt,
        expiredAt,
        usedAt,
        cancellationReason,
        parcel,
        authorizedUser,
      ];
}

class AuthorizationParcelInfo extends Equatable {
  final int id;
  final String trackingNumber;
  final String receiverName;

  const AuthorizationParcelInfo({
    required this.id,
    required this.trackingNumber,
    required this.receiverName,
  });

  @override
  List<Object?> get props => [id, trackingNumber, receiverName];
}

class AuthorizedUserInfo extends Equatable {
  final int id;
  final String userName;
  final String firstName;
  final String lastName;

  const AuthorizedUserInfo({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, userName, firstName, lastName];
}
