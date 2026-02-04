import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
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
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ConversationBloc>()
            ..add(InitializeConversationEvent(widget.conversationId)),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'نشط الآن',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: ShinyBackground(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ConversationError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(state.message),
                          ],
                        ),
                      );
                    } else if (state is ConversationLoaded) {
                      final messages = state.messages;
                      if (messages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "لا توجد رسائل بعد\nابدأ المحادثة الآن",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        );
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing4,
                          vertical: AppDimensions.spacing4,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.isFromCustomer;
                          final showAvatar =
                              index == 0 ||
                              messages[index - 1].isFromCustomer != isMe;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.spacing2,
                            ),
                            child: _buildMessageRow(message, isMe, showAvatar),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageRow(Message message, bool isMe, bool showAvatar) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe) ...[
          if (showAvatar)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primarySoft,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            )
          else
            const SizedBox(width: 32),
          const SizedBox(width: 8),
        ],
        Flexible(child: _buildMessageBubble(message, isMe)),
        if (isMe) ...[
          const SizedBox(width: 8),
          if (showAvatar)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            )
          else
            const SizedBox(width: 32),
        ],
      ],
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.type == 'text')
            Text(
              message.content ?? '',
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            )
          else if (message.type == 'image')
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black12,
                height: 150,
                width: 200,
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.attach_file,
                  color: isMe ? Colors.white : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'ملف مرفق',
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white70 : AppColors.textMuted,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                const Icon(Icons.done_all, size: 12, color: Colors.white70),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing3,
            vertical: AppDimensions.spacing2,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "اكتب رسالتك هنا...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<ConversationBloc, ConversationState>(
                  builder: (context, state) {
                    bool isLoading = false;
                    if (state is ConversationLoaded) {
                      isLoading = state.isSending;
                    }

                    return Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.send, color: Colors.white),
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
