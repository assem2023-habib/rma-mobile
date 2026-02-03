import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<GetConversationsEvent>(_onGetConversations);
    on<CreateConversationEvent>(_onCreateConversation);
  }

  Future<void> _onGetConversations(
    GetConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await chatRepository.getConversations();
    result.fold(
      (failure) => emit(const ChatError('Failed to load conversations')),
      (conversations) => emit(ChatLoaded(conversations)),
    );
  }

  Future<void> _onCreateConversation(
    CreateConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await chatRepository.createConversation(
      subject: event.subject,
      relatedType: event.relatedType,
      relatedId: event.relatedId,
    );
    result.fold(
      (failure) => emit(const ChatError('Failed to create conversation')),
      (conversation) {
        // After success, we might want to reload list or just navigate.
        // For now, emit success with the conversation so UI can navigate.
        emit(ChatOperationSuccess(conversation));
        // Optionally trigger reload for the list if needed by user
        add(GetConversationsEvent());
      },
    );
  }
}
