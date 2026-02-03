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
    // Helper to parse ID safely
    String parseId(dynamic id) {
      if (id == null) return '';
      return id.toString();
    }

    // New structure: fields are direct or within data
    final isRead = json['is_read'] == true || json['is_read'] == 1;

    return NotificationModel(
      id: parseId(json['id']),
      type: (json['notification_type'] ?? json['type']) as String?,
      title: json['title'] as String? ?? 'إشعار جديد',
      message: json['message'] as String? ?? '',
      data: json['data'] is Map ? json['data'] as Map<String, dynamic> : null,
      readAt: isRead
          ? (json['read_at'] != null
                ? DateTime.tryParse(json['read_at'].toString())
                : null)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
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
