import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/chat/messagedrawer.dart';
import 'package:guideurself/features/chat/messageinput.dart';
import 'package:guideurself/features/chat/messagelist.dart';
import 'package:guideurself/features/chat/questions.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:guideurself/widgets/textgradient.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class Chatbot extends HookWidget {
  const Chatbot({super.key});

  Future<List<Map<String, dynamic>>> getAllMessages(
      String conversationId) async {
    final messages = await getConversationMessages(conversationId);
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final question = useState<String?>(null);
    final messages = useState<List<Map<String, dynamic>>>([]);
    final isLoading = useState<bool>(false);

    final conversation = context.watch<ConversationProvider>().conversation;

    // Effect to fetch messages when conversation changes
    useEffect(() {
      final conversationId = conversation['conversation_id'];
      if (conversationId != null) {
        isLoading.value = true;
        getAllMessages(conversationId).then((fetchedMessages) {
          messages.value = fetchedMessages.reversed.toList();
        }).catchError((_) {
          // Handle error if needed
        }).whenComplete(() {
          isLoading.value = false;
        });
      }
      return null;
    }, [conversation]);

    // Handlers
    void handleSelectQuestion(String selectedQuestion) {
      question.value = selectedQuestion;
    }

    void sendQuestion(Map<String, dynamic> message) {
      messages.value = [
        message,
        ...messages.value,
      ];
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            
            context.go("/chat");
            FocusScope.of(context).unfocus();
            context.read<ConversationProvider>().resetConversation();
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
              size: 27,
            ),
          ),
        ],
        title: Text("Giga", style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      endDrawer: const MessageDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  final conversationId = conversation['conversation_id'];

                  if (conversationId != null) {
                    if (isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF12A5BC),
                        ),
                      );
                    }
                    return messages.value.isNotEmpty
                        ? MessageList(messages: messages.value)
                        : const Center(child: Text("No messages"));
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const GradientText(
                          "Hey there, I'm Giga!",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF12A5BC),
                              Color(0xFF0E46A3),
                            ],
                          ),
                        ),
                        const Gap(4),
                        SizedBox(
                          width: 280,
                          child: Text(
                            "Got questions? Ask away, and I'll do my best to help you out!",
                            textAlign: TextAlign.center,
                            style: styleText(
                              context: context,
                              fontSizeOption: FontSizeOption.size200,
                              lineHeightOption: LineHeightOption.height200,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            if (question.value == null &&
                messages.value.isEmpty &&
                (conversation["conversation_id"] == null))
              Questions(handleSelectQuestion: handleSelectQuestion)
            else
              const SizedBox.shrink(),
            MessageInput(
              question: question.value,
              handleSendQuestion: sendQuestion,
            ),
          ],
        ),
      ),
    );
  }
}
