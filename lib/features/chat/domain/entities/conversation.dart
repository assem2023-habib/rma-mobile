import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final int id;
  final String subject;
  final String? relatedType;
  final int? relatedId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? unreadCount;

  const Conversation({
    required this.id,
    required this.subject,
    this.relatedType,
    this.relatedId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount,
  });

  @override
  List<Object?> get props => [
    id,
    subject,
    relatedType,
    relatedId,
    status,
    createdAt,
    updatedAt,
    unreadCount,
  ];
}
