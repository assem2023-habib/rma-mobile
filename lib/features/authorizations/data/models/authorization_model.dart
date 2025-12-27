import '../../../../core/enums/authorization_status.dart';
import '../../domain/entities/authorization_entity.dart';

class AuthorizationModel extends AuthorizationEntity {
  const AuthorizationModel({
    required super.id,
    required super.userId,
    required super.parcelId,
    super.authorizedUserId,
    required super.authorizedUserType,
    required super.authorizedCode,
    required super.status,
    required super.generatedAt,
    required super.expiredAt,
    super.usedAt,
    super.cancellationReason,
    super.parcel,
    super.authorizedUser,
  });

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationModel(
      id: json['id'],
      userId: json['user_id'],
      parcelId: json['parcel_id'],
      authorizedUserId: json['authorized_user_id'],
      authorizedUserType: json['authorized_user_type'],
      authorizedCode: json['authorized_code'],
      status: AuthorizationStatus.fromString(json['authorized_status'] ?? 'Pending'),
      generatedAt: DateTime.parse(json['generated_at']),
      expiredAt: DateTime.parse(json['expired_at']),
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
      cancellationReason: json['cancellation_reason'],
      parcel: json['parcel'] != null
          ? AuthorizationParcelInfoModel.fromJson(json['parcel'])
          : null,
      authorizedUser: json['authorizedUser'] != null
          ? AuthorizedUserInfoModel.fromJson(json['authorizedUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'parcel_id': parcelId,
      'authorized_user_id': authorizedUserId,
      'authorized_user_type': authorizedUserType,
      'authorized_code': authorizedCode,
      'authorized_status': status.value,
      'generated_at': generatedAt.toIso8601String(),
      'expired_at': expiredAt.toIso8601String(),
      'used_at': usedAt?.toIso8601String(),
      'cancellation_reason': cancellationReason,
      'parcel': parcel != null
          ? AuthorizationParcelInfoModel.fromEntity(parcel!).toJson()
          : null,
      'authorizedUser': authorizedUser != null
          ? AuthorizedUserInfoModel.fromEntity(authorizedUser!).toJson()
          : null,
    };
  }
}

class AuthorizationParcelInfoModel extends AuthorizationParcelInfo {
  const AuthorizationParcelInfoModel({
    required super.id,
    required super.trackingNumber,
    required super.receiverName,
  });

  factory AuthorizationParcelInfoModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationParcelInfoModel(
      id: json['id'],
      trackingNumber: json['tracking_number'],
      receiverName: json['reciver_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_number': trackingNumber,
      'reciver_name': receiverName,
    };
  }

  factory AuthorizationParcelInfoModel.fromEntity(
      AuthorizationParcelInfo entity) {
    return AuthorizationParcelInfoModel(
      id: entity.id,
      trackingNumber: entity.trackingNumber,
      receiverName: entity.receiverName,
    );
  }
}

class AuthorizedUserInfoModel extends AuthorizedUserInfo {
  const AuthorizedUserInfoModel({
    required super.id,
    required super.userName,
    required super.firstName,
    required super.lastName,
  });

  factory AuthorizedUserInfoModel.fromJson(Map<String, dynamic> json) {
    return AuthorizedUserInfoModel(
      id: json['id'],
      userName: json['user_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory AuthorizedUserInfoModel.fromEntity(AuthorizedUserInfo entity) {
    return AuthorizedUserInfoModel(
      id: entity.id,
      userName: entity.userName,
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }
}
