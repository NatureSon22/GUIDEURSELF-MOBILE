import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<List<Map<String, dynamic>>> chatHeads() async {
  try {
    final response = await dio.get("/chats/heads");
    final List<dynamic> heads = response.data['chatHeads'] ?? [];
    return heads.map((e) => e as Map<String, dynamic>).toList();
  } on DioException catch (e) {
    debugPrint("Error fetching chat heads: ${e.message}");
    throw Exception('Failed to get chat heads.');
  }
}

Future<List<Map<String, dynamic>>> getMessages(String receiverId) async {
  try {
    final response = await dio.get("/chats/messages?receiver_id=$receiverId");
    final List<dynamic> messages = response.data['messages'] ?? [];
    return messages.map((e) => e as Map<String, dynamic>).toList();
  } on DioException catch (e) {
    debugPrint("Error fetching messages: ${e.message}");
    throw Exception('Failed to get messages.');
  }
}
