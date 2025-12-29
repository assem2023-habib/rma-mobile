import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.message,
    required super.data,
    super.readAt,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Handling the structure from the server response
    final pivot = json['pivot'] as Map<String, dynamic>?;
    final isRead = pivot != null
        ? (pivot['is_read'] == 1 || pivot['is_read'] == true)
        : false;

    return NotificationModel(
      id: json['id'] as int,
      type: json['notification_type'] as String?,
      title: json['title'] as String? ?? 'إشعار جديد',
      message: json['message'] as String? ?? '',
      data: json['data'] is Map ? json['data'] as Map<String, dynamic> : null,
      readAt: isRead ? DateTime.tryParse(pivot!['read_at'] ?? '') : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
