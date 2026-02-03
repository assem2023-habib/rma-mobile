import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.subject,
    super.relatedType,
    super.relatedId,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      subject: json['subject'] ?? 'No Subject',
      relatedType: json['related_type'],
      relatedId: json['related_id'],
      status: json['status'] ?? 'open',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      unreadCount: json['unread_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'related_type': relatedType,
      'related_id': relatedId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'unread_count': unreadCount,
    };
  }
}
