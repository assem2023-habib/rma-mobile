import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحادثات المباشرة'), // Localized: Live Chats
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatError) {
              return Center(child: Text(state.message));
            } else if (state is ChatLoaded) {
              if (state.conversations.isEmpty) {
                return const Center(child: Text("لا توجد محادثات حالياً"));
              }
              return ListView.separated(
                itemCount: state.conversations.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: const Icon(
                        Icons.support_agent,
                        color: Colors.blueAccent,
                      ),
                    ),
                    title: Text(
                      conversation.subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "الحالة: ${conversation.status}",
                      style: TextStyle(
                        color: conversation.status == 'open'
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                    trailing:
                        conversation.unreadCount != null &&
                            conversation.unreadCount! > 0
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      context.push(
                        '/chat/${conversation.id}',
                        extra: conversation.subject,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show dialog to create new conversation
            _showCreateConversationDialog(context);
          },
          child: const Icon(Icons.add_comment),
        ),
      ),
    );
  }

  void _showCreateConversationDialog(BuildContext context) {
    final subjectController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("محادثة جديدة"),
          content: TextField(
            controller: subjectController,
            decoration: const InputDecoration(hintText: "موضوع المحادثة"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                if (subjectController.text.isNotEmpty) {
                  // We need to access the bloc from the parent context
                  // But dialog has its own context. We need to pass the bloc or use a provider above.
                  // Since we provide ChatBloc in build, we can access it if we used a Builder or passed context.
                  // Here, standard way is to capture the bloc before showing dialog.
                  // However, since ChatListPage rebuilds, let's just use the current context of the widget
                  // BUT we are inside a static method logic effectively if we don't watch out.
                  // Actually, we can just use `context.read<ChatBloc>()` if we are inside the provider scope.
                  // Wait, `showDialog` is a new route, it might not inherit the provider if not careful.
                  // Best practice: Pass the bloc to the dialog.
                }
                // Simplified: Just returning true/data or handle in widget.
                // Let's implement differently:
                Navigator.pop(dialogContext, subjectController.text);
              },
              child: const Text("إنشاء"),
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null && result is String && result.isNotEmpty) {
        // We need the bloc context. Since showDialog is async, 'context' here is the ChatListPage context.
        // We need to wrap the whole Scaffold body or access it via GlobalKey, OR
        // Just wrap the FloatingActionButton logic correctly.
        // Since BlocProvider is created in build, `context` (passed to build) DOES NOT contain it yet.
        // We returned BlocProvider(child: Scaffold(...)).
        // So `context` in build is the parent.
        // We need a Builder or extract the body.
        // Refactoring slightly or using dirty trick?
        // Let's rely on extracting `ChatListView` or similar.
      }
    });

    // FIX logic:
    // The FB context does NOT have the bloc because BlocProvider is child of that context.
    // So interacting with the Bloc for 'add' event from FAB in this structure requires
    // wrapping the Scaffold or using a Builder.
  }
}

// Improved implementation with valid context access
class ChatListPageCorrect extends StatelessWidget {
  const ChatListPageCorrect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()..add(GetConversationsEvent()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('المحادثات المباشرة')),
          body: const ChatListView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _createConversation(context),
            child: const Icon(Icons.add_comment),
          ),
        ),
      ),
    );
  }

  void _createConversation(BuildContext context) {
    final subjectController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("محادثة جديدة"),
        content: TextField(
          controller: subjectController,
          decoration: const InputDecoration(hintText: "موضوع المحادثة"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, subjectController.text),
            child: const Text("إنشاء"),
          ),
        ],
      ),
    ).then((subject) {
      if (subject != null && subject.toString().isNotEmpty) {
        context.read<ChatBloc>().add(CreateConversationEvent(subject: subject));
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(
                conversationId: state.conversation.id,
                subject: state.conversation.subject,
              ),
            ),
          ).then((_) => context.read<ChatBloc>().add(GetConversationsEvent()));
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
          } else if (state is ChatLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(child: Text("لا توجد محادثات حالياً"));
            }
            return ListView.separated(
              itemCount: state.conversations.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text(
                    conversation.subject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    conversation.status,
                    style: const TextStyle(color: Colors.grey),
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
                    ).then(
                      (_) =>
                          context.read<ChatBloc>().add(GetConversationsEvent()),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
