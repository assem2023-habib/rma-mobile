import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesEvent extends ConversationEvent {
  final int conversationId;
  const LoadMessagesEvent(this.conversationId);
  @override
  List<Object> get props => [conversationId];
}

class SendMessageEvent extends ConversationEvent {
  final int conversationId;
  final String? content;
  final File? attachment;

  const SendMessageEvent(this.conversationId, {this.content, this.attachment});

  @override
  List<Object> get props => [conversationId, content ?? '', attachment ?? ''];
}

class MessageReceivedEvent extends ConversationEvent {
  final Map<String, dynamic> data;
  const MessageReceivedEvent(this.data);
  @override
  List<Object> get props => [data];
}

class InitializeConversationEvent extends ConversationEvent {
  final int conversationId;
  const InitializeConversationEvent(this.conversationId);
  @override
  List<Object> get props => [conversationId];
}
