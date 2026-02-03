import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Message> messages;
  final bool isSending; // To show loading indicator for sending

  const ConversationLoaded({required this.messages, this.isSending = false});

  ConversationLoaded copyWith({List<Message>? messages, bool? isSending}) {
    return ConversationLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object> get props => [messages, isSending];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}
