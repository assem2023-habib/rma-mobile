import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import 'package:rma_customer/core/api/api_config.dart';
import '../../../../core/api/token_manager.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel> createConversation({
    required String subject,
    String? relatedType,
    int? relatedId,
  });
  Future<ConversationModel> getConversation(int id);
  Future<List<MessageModel>> getMessages(int conversationId, {int page = 1});
  Future<MessageModel> sendMessage(
    int conversationId, {
    String? content,
    File? attachment,
  });
  Future<void> closeConversation(int conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final TokenManager tokenManager;

  ChatRemoteDataSourceImpl({required this.client, required this.tokenManager});

  @override
  Future<List<ConversationModel>> getConversations() async {
    final token = tokenManager.getToken();
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/chat/conversations'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> conversationsJson =
          data['data']; // Assuming paginated or nested under data
      return conversationsJson
          .map((json) => ConversationModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ConversationModel> createConversation({
    required String subject,
    String? relatedType,
    int? relatedId,
  }) async {
    final token = tokenManager.getToken();
    final body = {
      'subject': subject,
      if (relatedType != null) 'related_type': relatedType,
      if (relatedId != null) 'related_id': relatedId.toString(),
    };

    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/chat/conversations'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      // Depending on API response structure, might need adjustments
      // Assuming return is the conversation object or wrapper
      final conversationData = json['data'] ?? json;
      return ConversationModel.fromJson(conversationData);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ConversationModel> getConversation(int id) async {
    final token = tokenManager.getToken();
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/chat/conversations/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ConversationModel.fromJson(json['data'] ?? json);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getMessages(
    int conversationId, {
    int page = 1,
  }) async {
    final token = tokenManager.getToken();
    final response = await client.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/chat/conversations/$conversationId/messages?page=$page',
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> messagesJson =
          data['data']; // Assuming paginated response
      return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MessageModel> sendMessage(
    int conversationId, {
    String? content,
    File? attachment,
  }) async {
    final token = tokenManager.getToken();
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/chat/conversations/$conversationId/messages',
    );

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    if (content != null) {
      request.fields['content'] = content;
    }

    if (attachment != null) {
      request.files.add(
        await http.MultipartFile.fromPath('attachment', attachment.path),
      );
    }

    final streamlinedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamlinedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      // Assuming 'data' contains the message object
      return MessageModel.fromJson(json['data'] ?? json);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> closeConversation(int conversationId) async {
    final token = tokenManager.getToken();
    final response = await client.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/chat/conversations/$conversationId/close',
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
