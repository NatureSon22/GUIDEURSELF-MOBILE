import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:provider/provider.dart';

class MessageInput extends StatefulWidget {
  final String? question;
  final void Function(Map<String, dynamic> question) handleSendQuestion;

  const MessageInput({
    super.key,
    required this.question,
    required this.handleSendQuestion,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _controller.text = widget.question!;
    }
  }

  @override
  void didUpdateWidget(covariant MessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question && widget.question != null) {
      _controller.text = widget.question!;
      SystemChannels.textInput.invokeMethod("TextInput.show");
    }
  }

  Future<void> handleSendQuestion({required String question}) async {
    final conversationProvider =
        Provider.of<ConversationProvider>(context, listen: false);
    final conversation = conversationProvider.conversation;

    // Optimistically show user message
    final String? initialConversationId = conversation['conversation_id'];

    widget.handleSendQuestion(
      {
        "_id": initialConversationId,
        "content": question,
        "is_machine_generated": false,
      },
    );

    _controller.clear();

    Map<String, dynamic>? newConversation;

    // If no conversation_id, create a new one
    String conversationId = initialConversationId ?? '';
    if (initialConversationId == null) {
      newConversation = await createConversation(name: question);
      conversationId = newConversation["conversation_id"];
      conversationProvider.setConversation(conversation: newConversation);
    }

    try {
      final response = await sendMessage(
        conversationId: conversationId,
        content: question,
      );

      // Use the correct conversation_id after creation for bot response
      final resolvedConversationId =
          initialConversationId ?? newConversation?['conversation_id'];

      final responseMessage = {
        "_id": resolvedConversationId,
        "content": response["answer"]["content"],
        "is_machine_generated": true,
      };

      widget.handleSendQuestion(responseMessage);
    } catch (e) {
      // Use the correct conversation_id after creation for failed message
      final resolvedConversationId =
          initialConversationId ?? newConversation?['conversation_id'];

      widget.handleSendQuestion({
        "_id": resolvedConversationId,
        "content": "Failed to send message. Please try again.",
        "is_machine_generated": true,
        "is_failed": true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 13),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF323232).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: BorderSide(
                color: const Color(0xFF323232).withOpacity(0.1),
                width: 1,
              ),
              padding: const EdgeInsets.all(8),
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.mic_none_sharp,
              size: 20,
            ),
          ),
          const Gap(4),
          Expanded(
            child: TextField(
              autofocus: false,
              style: const TextStyle(fontSize: 12),
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type something here...",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF323232).withOpacity(0.3),
                    width: 0.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF323232).withOpacity(0.8),
                    width: 0.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          const Gap(4),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                handleSendQuestion(question: _controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(11),
            ),
            child: Transform.rotate(
              angle: -0.785398,
              child: const Icon(
                Icons.send,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
