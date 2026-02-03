import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()..add(GetConversationsEvent()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('المحادثات المباشرة')),
          body: const ChatListView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateConversationDialog(context),
            child: const Icon(Icons.add_comment),
          ),
        ),
      ),
    );
  }

  void _showCreateConversationDialog(BuildContext context) {
    final subjectController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("محادثة جديدة"),
        content: TextField(
          controller: subjectController,
          decoration: const InputDecoration(hintText: "موضوع المحادثة"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, subjectController.text),
            child: const Text("إنشاء"),
          ),
        ],
      ),
    ).then((subject) {
      if (subject != null && subject.trim().isNotEmpty && context.mounted) {
        context.read<ChatBloc>().add(
          CreateConversationEvent(subject: subject.trim()),
        );
      }
    });
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatOperationSuccess) {
          // Navigate to detail page after successful creation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(
                conversationId: state.conversation.id,
                subject: state.conversation.subject,
              ),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<ChatBloc>().add(GetConversationsEvent());
            }
          });
        }
        if (state is ChatError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "لا توجد محادثات حالياً",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatBloc>().add(GetConversationsEvent());
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.conversations.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.support_agent,
                        color: Colors.blueAccent,
                      ),
                    ),
                    title: Text(
                      conversation.subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: conversation.status == 'open'
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          conversation.status == 'open' ? 'نشطة' : 'مغلقة',
                          style: TextStyle(
                            color: conversation.status == 'open'
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing:
                        conversation.unreadCount != null &&
                            conversation.unreadCount! > 0
                        ? Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailPage(
                            conversationId: conversation.id,
                            subject: conversation.subject,
                          ),
                        ),
                      ).then((_) {
                        if (context.mounted) {
                          context.read<ChatBloc>().add(GetConversationsEvent());
                        }
                      });
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
