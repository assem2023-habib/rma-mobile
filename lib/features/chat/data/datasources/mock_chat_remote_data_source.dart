import 'dart:io';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'chat_remote_data_source.dart';

class MockChatRemoteDataSource implements ChatRemoteDataSource {
  final List<ConversationModel> _mockConversations = [
    ConversationModel(
      id: 1,
      subject: 'استفسار عن طرد متأخر',
      status: 'open',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
    ),
    ConversationModel(
      id: 2,
      subject: 'تغيير عنوان الاستلام',
      status: 'open',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
    ConversationModel(
      id: 3,
      subject: 'شكوى بخصوص تلف محتويات',
      status: 'closed',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
      unreadCount: 0,
    ),
  ];

  final Map<int, List<MessageModel>> _mockMessages = {
    1: [
      MessageModel(
        id: 1,
        uuid: 'uuid-1',
        conversationId: 1,
        senderType: 'customer',
        senderId: 1,
        senderName: 'أحمد المحمد',
        content: 'مرحباً، طردي رقم RMA-10001 لم يصل بعد',
        type: 'text',
        isFromCustomer: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MessageModel(
        id: 2,
        uuid: 'uuid-2',
        conversationId: 1,
        senderType: 'staff',
        senderId: 99,
        senderName: 'الدعم الفني',
        content: 'أهلاً بك سيد أحمد، نحن نعتذر عن التأخير. الطرد حالياً في مركز التوزيع بحلب.',
        type: 'text',
        isFromCustomer: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      MessageModel(
        id: 3,
        uuid: 'uuid-3',
        conversationId: 1,
        senderType: 'customer',
        senderId: 1,
        senderName: 'أحمد المحمد',
        content: 'متى يتوقع وصوله؟',
        type: 'text',
        isFromCustomer: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  };

  @override
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockConversations;
  }

  @override
  Future<ConversationModel> createConversation({
    required String subject,
    String? relatedType,
    int? relatedId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final newConv = ConversationModel(
      id: _mockConversations.length + 1,
      subject: subject,
      relatedType: relatedType,
      relatedId: relatedId,
      status: 'open',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      unreadCount: 0,
    );
    return newConv;
  }

  @override
  Future<ConversationModel> getConversation(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockConversations.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<MessageModel>> getMessages(int conversationId, {int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockMessages[conversationId] ?? [];
  }

  @override
  Future<MessageModel> sendMessage(
    int conversationId, {
    String? content,
    File? attachment,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      uuid: 'new-uuid-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderType: 'customer',
      senderId: 1,
      senderName: 'أحمد المحمد',
      content: content,
      type: attachment != null ? 'file' : 'text',
      attachmentName: attachment?.path.split('/').last,
      isFromCustomer: true,
      createdAt: DateTime.now(),
    );
    return newMessage;
  }

  @override
  Future<void> closeConversation(int conversationId) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
