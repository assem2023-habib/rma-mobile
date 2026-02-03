import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.uuid,
    required super.conversationId,
    required super.senderType,
    required super.senderId,
    required super.senderName,
    super.content,
    required super.type,
    super.attachmentUrl,
    super.attachmentName,
    required super.isFromCustomer,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      uuid: json['uuid'],
      conversationId: json['conversation_id'],
      senderType: json['sender_type'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      content: json['content'],
      type: json['type'],
      attachmentUrl: json['attachment_url'],
      attachmentName: json['attachment_name'],
      isFromCustomer: json['is_from_customer'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'conversation_id': conversationId,
      'sender_type': senderType,
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
      'type': type,
      'attachment_url': attachmentUrl,
      'attachment_name': attachmentName,
      'is_from_customer': isFromCustomer,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
