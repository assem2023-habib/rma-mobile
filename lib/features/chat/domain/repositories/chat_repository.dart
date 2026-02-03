import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Conversation>>> getConversations();
  Future<Either<Failure, Conversation>> createConversation({
    required String subject,
    String? relatedType,
    int? relatedId,
  });
  Future<Either<Failure, Conversation>> getConversation(int id);
  Future<Either<Failure, List<Message>>> getMessages(
    int conversationId, {
    int page = 1,
  });
  Future<Either<Failure, Message>> sendMessage(
    int conversationId, {
    String? content,
    File? attachment,
  });
  Future<Either<Failure, void>> closeConversation(int conversationId);
}
