import '../../domain/entities/authorization_entity.dart';

class AuthorizationModel extends AuthorizationEntity {
  const AuthorizationModel({
    required super.id,
    required super.title,
    required super.status,
    required super.date,
    required super.description,
  });

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory AuthorizationModel.fromEntity(AuthorizationEntity entity) {
    return AuthorizationModel(
      id: entity.id,
      title: entity.title,
      status: entity.status,
      date: entity.date,
      description: entity.description,
    );
  }
}
