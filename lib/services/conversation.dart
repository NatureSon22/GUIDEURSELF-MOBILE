import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import 'package:http/http.dart' as http;

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

Future<Map<String, dynamic>> createConversationAsGuest(
    {required String name}) async {
  try {
    final response = await dio.post(
      "/conversation/create-conversation-as-guest",
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

Future<List<Map<String, dynamic>>> getAllConversations({int limit = 0}) async {
  try {
    final response = await dio.get("/conversation/get-all-conversations");
    final data = response.data as Map<String, dynamic>;

    List<Map<String, dynamic>> conversations =
        data["conversations"]?.cast<Map<String, dynamic>>() ?? [];

    // If there's a limit, reverse the list first
    if (limit > 0) {
      conversations = conversations.reversed.toList();
      return conversations.take(limit).toList();
    }

    // Otherwise, return normally
    return conversations;
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
        "content": "MOBILE: $content",
      },
    );

    return response.data;
  } on DioException catch (_) {
    throw Exception('Failed to send message. Please try again.');
  }
}

Future<void> reviewIsHelpful(
    {required messageId, required isHelpful, reason}) async {
  try {
    final response = await dio.put(
      "/message/review-message",
      data: {"id": messageId, "is_helpful": isHelpful, "reason": reason},
    );

    print(response.data);
  } on DioException catch (_) {
    throw Exception('Failed to delete conversation');
  }
}

Future<String> transcribeAudio(String filePath) async {
  final url = Uri.parse(
      "https://api.deepgram.com/v1/listen?model=nova-3&smart_format=true");

  // Check if file exists
  final File file = File(filePath);
  if (!await file.exists()) {
    print("File does not exist: $filePath");
    return "Error: File not found";
  }

  try {
    final List<int> fileBytes = await file.readAsBytes();

    final request = http.Request("POST", url);
    request.headers["Authorization"] =
        "Token c87148c253bf5f5c4088f7f12bebace1b36bb9af";
    request.headers["Content-Type"] = "audio/wav";
    request.bodyBytes = fileBytes;

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      final responseBody = await streamedResponse.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      final String transcript = jsonResponse['results']['channels'][0]
          ['alternatives'][0]['transcript'];

      print("Transcript: $transcript");
      return transcript;
    } else {
      final errorResponse = await streamedResponse.stream.bytesToString();
      print("Error ${streamedResponse.statusCode}: $errorResponse");
      return "Error: ${streamedResponse.statusCode} - $errorResponse";
    }
  } catch (e) {
    print("Exception: $e");
    return "Exception: $e";
  }
}
