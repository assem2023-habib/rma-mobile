import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/live_notification_service.dart';
import '../../data/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ChatRepository chatRepository;
  final LiveNotificationService liveNotificationService;
  StreamSubscription? _liveStreamSubscription;
  int? _currentConversationId;

  ConversationBloc({
    required this.chatRepository,
    required this.liveNotificationService,
  }) : super(ConversationInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<InitializeConversationEvent>(_onInitializeConversation);
    on<MessageReceivedEvent>(_onMessageReceived);
  }

  Future<void> _onInitializeConversation(
    InitializeConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    _currentConversationId = event.conversationId;

    // Unsubscribe from previous if any (though typically bloc is scoped per page)
    // But good practice if reused.
    // For now assuming 1 page instance = 1 conversation.

    // Subscribe to real-time channel
    await liveNotificationService.subscribeToConversation(event.conversationId);

    // Listen to global stream and filter
    _liveStreamSubscription = liveNotificationService.eventStream.listen((
      eventData,
    ) {
      if (eventData is Map && eventData['type'] == 'chat_message') {
        final data = eventData['data'];
        // Verify this message belongs to current conversation
        if (data['conversation_id'].toString() ==
            _currentConversationId.toString()) {
          add(MessageReceivedEvent(data));
        }
      }
    });

    // Load initial messages
    add(LoadMessagesEvent(event.conversationId));
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    final result = await chatRepository.getMessages(event.conversationId);
    result.fold(
      (failure) => emit(const ConversationError('Failed to load messages')),
      (messages) => emit(ConversationLoaded(messages: messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ConversationState> emit,
  ) async {
    final currentState = state;
    if (currentState is ConversationLoaded) {
      emit(currentState.copyWith(isSending: true));

      final result = await chatRepository.sendMessage(
        event.conversationId,
        content: event.content,
        attachment: event.attachment,
      );

      result.fold(
        (failure) {
          emit(currentState.copyWith(isSending: false));
          // Could emit a snackbar error or separate state
        },
        (message) {
          // Add message locally to the list or wait for realtime?
          // Optimistic UI: Add it now.
          // Note: Realtime might send it back. We should handle duplicates if needed.
          // For now, append it.
          final updatedMessages = List.of(currentState.messages)..add(message);
          emit(ConversationLoaded(messages: updatedMessages, isSending: false));
        },
      );
    }
  }

  Future<void> _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<ConversationState> emit,
  ) async {
    final currentState = state;
    if (currentState is ConversationLoaded) {
      try {
        final newMessage = MessageModel.fromJson(event.data);
        // Check if already exists (optimistic UI might have added it)
        // We simple check ID or UUID if standard.
        final exists = currentState.messages.any((m) => m.id == newMessage.id);
        if (!exists) {
          final updatedMessages = List.of(currentState.messages)
            ..add(newMessage);
          emit(currentState.copyWith(messages: updatedMessages));
        }
      } catch (e) {
        // error parsing
      }
    }
  }

  @override
  Future<void> close() {
    if (_currentConversationId != null) {
      liveNotificationService.unsubscribeFromConversation(
        _currentConversationId!,
      );
    }
    _liveStreamSubscription?.cancel();
    return super.close();
  }
}
