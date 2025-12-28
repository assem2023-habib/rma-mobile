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
    // Laravel notifications typically have a specific structure
    final dataMap = json['data'] as Map<String, dynamic>? ?? {};
    
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String? ?? (dataMap['type'] as String? ?? 'unknown'),
      title: dataMap['title'] as String? ?? _getDefaultTitle(json['type'] as String?),
      message: dataMap['message'] as String? ?? _getDefaultMessage(dataMap),
      data: dataMap,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static String _getDefaultTitle(String? type) {
    switch (type) {
      case 'parcel_status_updated':
        return 'تحديث حالة الطرد';
      case 'appointment_confirmed':
        return 'تأكيد الموعد';
      case 'authorization_status_updated':
        return 'تحديث التخويل';
      case 'pickup_reminder':
        return 'تذكير بالاستلام';
      default:
        return 'إشعار جديد';
    }
  }

  static String _getDefaultMessage(Map<String, dynamic> data) {
    if (data.containsKey('tracking_number')) {
      return 'تحديث بخصوص الطرد رقم: ${data['tracking_number']}';
    }
    return 'لديك تنبيه جديد في النظام';
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
