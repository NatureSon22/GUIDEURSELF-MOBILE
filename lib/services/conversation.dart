import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

// conversations
Future<Map<String, dynamic>> createConversation({required String name}) async {
  try {
    final response = await dio.post(
      "/conversation/create-conversation",
      data: {
        "name": name,
      },
    );

    final newConversation =
        response.data["newConversation"] as Map<String, dynamic>;

    final setConversation = Map<String, dynamic>.from(newConversation);
    setConversation["id"] = newConversation["conversation_id"];

    return setConversation;
  } on DioException catch (_) {
    throw Exception('Failed to create conversation. Please try again.');
  }
}

Future<List<Map<String, dynamic>>> getAllConversations() async {
  try {
    final response = await dio.get("/conversation/get-all-conversations");
    final data = response.data as Map<String, dynamic>;

    return data["conversations"]?.cast<Map<String, dynamic>>() ?? [];
  } on DioException catch (_) {
    throw Exception('Failed to fetch conversations');
  }
}

Future<List<Map<String, dynamic>>> getConversationMessages(
    String conversationId) async {
  try {
    final response =
        await dio.get("/conversation/get-conversation/$conversationId");
    final messages =
        response.data["messages"]?.cast<Map<String, dynamic>>() ?? [];
    return messages;
  } on DioException catch (_) {
    throw Exception('Failed to fetch messages');
  }
}

Future<void> deleteConversation(String conversationId) async {
  try {
    final response =
        await dio.delete("/conversation/delete-conversation/$conversationId");
    print(response.data);
  } on DioException catch (_) {
    throw Exception('Failed to delete conversation');
  }
}

// messages
Future<Map<String, dynamic>> sendMessage({
  required String conversationId,
  required String content,
}) async {
  try {
    final response = await dio.post(
      "/message/send-message",
      data: {
        "conversation_id": conversationId,
        "content": content,
      },
    );

    return response.data;
  } on DioException catch (_) {
    throw Exception('Failed to send message. Please try again.');
  }
}

Future<void> reviewIsHelpful({required messageId, required isHelpful}) async {
  try {
    final response = await dio.put(
      "/message/review-message",
      data: {"id": messageId, "is_helpful": isHelpful},
    );

    print(response.data);
  } on DioException catch (_) {
    throw Exception('Failed to delete conversation');
  }
}
