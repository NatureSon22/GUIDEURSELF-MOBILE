import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket socket;
  bool _isConnected = false;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void connect() {
    if (_isConnected) return;

    socket = io.io('https://guideurself-web.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      debugPrint('Socket connected');
      _isConnected = true;
    });

    socket.onDisconnect((_) {
      debugPrint('Socket disconnected');
      _isConnected = false;
    });

    socket.onReconnect((_) {
      debugPrint('Socket reconnected');
    });

    socket.onError((data) {
      debugPrint('Socket error: $data');
    });

    socket.connect();
  }

  void joinRoom(String userId) {
    if (_isConnected) {
      socket.emit("join", userId);
      debugPrint("Joined room: $userId");
    } else {
      debugPrint("Cannot join room, socket not connected.");
    }
  }

  void sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    List<Map> files = const [],
  }) {
    if (_isConnected) {
      socket.emit("sendMessage", {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "content": content,
        "files": files
      });
    } else {
      debugPrint("Cannot send message, socket not connected.");
    }
  }

  void markMessagesAsRead(String senderId, String receiverId) {
    if (_isConnected) {
      socket.emit("markAsRead", {
        "sender_id": senderId,
        "receiver_id": receiverId,
      });
    } else {
      debugPrint("Cannot mark messages as read, socket not connected.");
    }
  }

  void listenForMessages(Function(dynamic) callback) {
    socket.on("receiveMessage", (data) {
      print("Received message: $data");
      callback(data);
    });
  }

  void dispose() {
    socket.dispose();
    _isConnected = false;
    debugPrint("Socket disconnected and disposed.");
  }
}
