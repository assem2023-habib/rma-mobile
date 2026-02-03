import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/conversation_bloc.dart';
import '../bloc/conversation_event.dart';
import '../bloc/conversation_state.dart';
import '../../domain/entities/message.dart';

class ChatDetailPage extends StatefulWidget {
  final int conversationId;
  final String subject;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
    required this.subject,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ConversationBloc>()
            ..add(InitializeConversationEvent(widget.conversationId)),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.subject)),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ConversationError) {
                    return Center(child: Text(state.message));
                  } else if (state is ConversationLoaded) {
                    final messages = state.messages;
                    if (messages.isEmpty) {
                      return const Center(child: Text("ابدأ المحادثة..."));
                    }

                    // Scroll to bottom on new message
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _buildMessageBubble(message);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message
        .isFromCustomer; // Assuming 'isFromCustomer' means SENT by me (the app user)
    // Actually, 'isFromCustomer' field in Message entity determines if it was sent by the customer.
    // Since this is the Customer App, if isFromCustomer is true, it's MY message.

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe
                ? const Radius.circular(12)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.type == 'text')
              Text(
                message.content ?? '',
                style: TextStyle(color: isMe ? Colors.white : Colors.black87),
              )
            else if (message.type == 'image')
              const Icon(
                Icons.image,
                color: Colors.white,
              ) // Placeholder for image
            else
              const Icon(
                Icons.attach_file,
                color: Colors.white,
              ), // Placeholder for file

            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext rootContext) {
    // We need to access the Bloc from the context provided by BlocProvider.
    // Since this method is built inside the BlocProvider child tree (Scaffold body),
    // we can access it via 'context' if passed responsibly, but here 'rootContext'
    // is passed from 'build'.
    // WAIT. 'build' wraps Scaffold in BlocProvider. So 'rootContext' (from build)
    // DOES NOT have the provider. We need to use Builder or access context from inside Scaffold.

    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "اكتب رسالتك هنا...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  bool isLoading = false;
                  if (state is ConversationLoaded) {
                    isLoading = state.isSending;
                  }

                  return IconButton(
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_messageController.text.trim().isNotEmpty) {
                              context.read<ConversationBloc>().add(
                                SendMessageEvent(
                                  widget.conversationId,
                                  content: _messageController.text,
                                ),
                              );
                              _messageController.clear();
                            }
                          },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
