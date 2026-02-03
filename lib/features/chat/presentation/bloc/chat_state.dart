import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Conversation> conversations;

  const ChatLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatOperationSuccess extends ChatState {
  final Conversation conversation;
  const ChatOperationSuccess(this.conversation);

  @override
  List<Object> get props => [conversation];
}
