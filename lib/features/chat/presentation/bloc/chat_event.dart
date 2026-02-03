import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetConversationsEvent extends ChatEvent {}

class CreateConversationEvent extends ChatEvent {
  final String subject;
  final String? relatedType;
  final int? relatedId;

  const CreateConversationEvent({
    required this.subject,
    this.relatedType,
    this.relatedId,
  });

  @override
  List<Object> get props => [subject, relatedType ?? '', relatedId ?? 0];
}
