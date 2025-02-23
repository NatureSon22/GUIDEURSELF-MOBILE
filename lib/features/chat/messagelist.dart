import 'package:flutter/material.dart';
import 'package:guideurself/features/chat/messagebubble.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key, required this.messages});

  final List messages;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return MessageBubble(
          messageId: message["_id"],
          content: message["content"],
          isMachine: message["is_machine_generated"],
          isFailed: message["is_failed"] ?? false,
          initialIsHelpful: message["is_helpful"] as bool?,
        );
      },
    );
  }
}
