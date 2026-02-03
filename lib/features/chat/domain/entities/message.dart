import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int id;
  final String uuid;
  final int conversationId;
  final String senderType;
  final int senderId;
  final String senderName;
  final String? content;
  final String type; // text, file, image
  final String? attachmentUrl;
  final String? attachmentName;
  final bool isFromCustomer;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.uuid,
    required this.conversationId,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    this.content,
    required this.type,
    this.attachmentUrl,
    this.attachmentName,
    required this.isFromCustomer,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    uuid,
    conversationId,
    senderType,
    senderId,
    senderName,
    content,
    type,
    attachmentUrl,
    attachmentName,
    isFromCustomer,
    createdAt,
  ];
}
