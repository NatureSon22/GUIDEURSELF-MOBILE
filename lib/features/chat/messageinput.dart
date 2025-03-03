import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/features/chat/recordinput.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
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
    final loadingProvider = context.read<LoadingProvider>();
    final conversation = conversationProvider.conversation;
    String? conversationId = conversation['conversation_id'];

    final String tempMessageId =
        DateTime.now().millisecondsSinceEpoch.toString();

    // Immediately show the user's question in the UI
    widget.handleSendQuestion({
      "_id": tempMessageId,
      "content": question,
      "is_machine_generated": false,
    });

    _controller.clear();

    try {
      // If there's no conversation, create a temporary one
      if (conversationId == null) {
        if (conversation.isEmpty) {
          final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
          conversationProvider.setConversation(
              conversation: {'conversation_id': tempId}, isNew: true);
          conversationId = tempId;
        }

        // Create a new conversation in the backend
        final newConversation = await createConversation(name: question);

        if (!newConversation.containsKey("conversation_id")) {
          throw Exception(
              "Invalid conversation response: Missing conversation_id");
        }

        // Update the conversation with the real ID
        conversationProvider.setConversation(conversation: newConversation);
        conversationId = newConversation["conversation_id"];
      }

      loadingProvider.setIsGeneratingResponse(true);

      // Send the message to the backend
      final response =
          await sendMessage(conversationId: conversationId!, content: question);

      widget.handleSendQuestion({
        "_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "content": response["answer"]["content"],
        "is_machine_generated": true,
      });

      loadingProvider.setIsGeneratingResponse(false);
    } catch (e) {
      // More detailed error handling
      final String errorMessage;
      if (e.toString().contains("network")) {
        errorMessage = "Network error. Please check your connection.";
      } else if (e.toString().contains("500")) {
        errorMessage = "Server error. Please try again later.";
      } else {
        errorMessage = "Failed to send message. Please try again.";
      }

      // Show error message in the UI
      widget.handleSendQuestion({
        "_id": conversationId ?? tempMessageId,
        "content": errorMessage,
        "is_machine_generated": true,
        "is_failed": true,
      });

      debugPrint("Message error: $e");
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
            onPressed: () => recordInput(context, widget.handleSendQuestion),
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
