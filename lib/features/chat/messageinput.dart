import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/features/chat/recordinput.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/apperance.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:guideurself/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MessageInput extends StatefulWidget {
  final String? question;
  final void Function(Map<String, dynamic> question) handleSendQuestion;
  final void Function(String selectedQuestion) handleSelectQuestion;

  const MessageInput(
      {super.key,
      required this.question,
      required this.handleSendQuestion,
      required this.handleSelectQuestion});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final storage = StorageService();

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

  void outOfQueries() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text(
                "Oops! You've reached your limit for this feature. Log in for more access.",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11.5,
                    height: 1.5,
                    color: Color(0xFF323232)),
              ),
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go("/login");
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleSendQuestion({required String question}) async {
    final conversationProvider =
        Provider.of<ConversationProvider>(context, listen: false);
    final loadingProvider = context.read<LoadingProvider>();
    final conversation = conversationProvider.conversation;
    final accountProvider = context.read<AccountProvider>();
    final account = accountProvider.account;
    final isGuest = account.isEmpty;
    String? conversationId = conversation['conversation_id'];
    int query = storage.getData(key: "query") ?? 0;

    if (isGuest == true && query == 5) {
      outOfQueries();
      return;
    }

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
        final newConversation = isGuest
            ? await createConversationAsGuest(name: question)
            : await createConversation(name: question);

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
        "_id": response["answer"]["id"],
        "content": response["answer"]["content"],
        "is_machine_generated": true,
      });

      loadingProvider.setIsGeneratingResponse(false);

      if (isGuest) {
        storage.saveData(key: "query", value: query + 1);
      }
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

      loadingProvider.setIsGeneratingResponse(false);

      //Show error message in the UI
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
    final accountProvider = context.read<AccountProvider>();
    final isDarkMode = context.watch<AppearanceProvider>().isDarkMode;
    final account = accountProvider.account;
    final isGuest = account.isEmpty;
    int query = storage.getData(key: "query") ?? 0;

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
            onPressed: () {
              if (query == 5 && isGuest) {
                outOfQueries();
                return;
              }
              recordInput(context, widget.handleSendQuestion,
                  widget.handleSelectQuestion);
            },
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
              FontAwesomeIcons.microphoneLines,
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
                filled: isDarkMode,
                fillColor:
                    isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
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
            iconAlignment: IconAlignment.end,
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                handleSendQuestion(question: _controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(11),
            ),
            child: const Icon(
              FontAwesomeIcons.solidPaperPlane,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
