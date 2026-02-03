import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      final result = await remoteDataSource.getConversations();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Conversation>> createConversation({
    required String subject,
    String? relatedType,
    int? relatedId,
  }) async {
    try {
      final result = await remoteDataSource.createConversation(
        subject: subject,
        relatedType: relatedType,
        relatedId: relatedId,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Conversation>> getConversation(int id) async {
    try {
      final result = await remoteDataSource.getConversation(id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    int conversationId, {
    int page = 1,
  }) async {
    try {
      final result = await remoteDataSource.getMessages(
        conversationId,
        page: page,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(
    int conversationId, {
    String? content,
    File? attachment,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        conversationId,
        content: content,
        attachment: attachment,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> closeConversation(int conversationId) async {
    try {
      await remoteDataSource.closeConversation(conversationId);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
