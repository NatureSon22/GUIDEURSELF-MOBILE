import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/chat/messagedrawer.dart';
import 'package:guideurself/features/chat/messageinput.dart';
import 'package:guideurself/features/chat/messagelist.dart';
import 'package:guideurself/features/chat/questions.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/bottomnav.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:guideurself/services/storage.dart';
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
    final isCreatingConversation = useState<bool>(false);
    final accountProvider = context.read<AccountProvider>();
    final bottomNavProvider = context.watch<BottomNavProvider>();
    final account = accountProvider.account;
    final isGuest = account.isEmpty;
    final StorageService storage = StorageService();

    final conversation = context.watch<ConversationProvider>().conversation;
    final isNewConversation =
        context.watch<ConversationProvider>().isNewConversation;
    final isGeneratingResponse =
        context.watch<LoadingProvider>().isGeneratingResponse;

    // Extract conversationId for easier reference
    final conversationId = conversation['conversation_id'];

    final extras =
        GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};
    useEffect(() {
      // Only reset messages when explicitly starting a new conversation
      // but not when we're in the process of creating one
      if (isNewConversation &&
          !(conversationId != null &&
              conversationId.toString().startsWith('temp-')) &&
          !isCreatingConversation.value) {
        messages.value = [];
        isCreatingConversation.value = false;
        return null;
      }

      // Only fetch messages for established conversations (not temporary ones)
      if (conversationId != null &&
          !conversationId.toString().startsWith('temp-') &&
          !isCreatingConversation.value) {
        isLoading.value = true;

        getAllMessages(conversationId).then((fetchedMessages) {
          // Only update messages if we get valid results and aren't creating a conversation
          if (fetchedMessages.isNotEmpty) {
            messages.value = fetchedMessages.reversed.toList();
          } else if (messages.value.isEmpty) {
            // Only set to empty if we don't already have messages (optimistic updates)
            messages.value = [];
          }
        }).catchError((error) {
          debugPrint("Error fetching messages: $error");
          // Do not clear existing messages on error
        }).whenComplete(() {
          isLoading.value = false;
        });
      } else if (!isCreatingConversation.value) {
        // Only reset for brand new conversations, not during creation
        if (conversationId == null) {
          messages.value = [];
        }
        isLoading.value = false;
      }

      return null;
    }, [conversation, isNewConversation]);

    // Track conversation creation state changes
    useEffect(() {
      // If we have messages but the conversation ID is temporary or null,
      // we're in the process of creating a conversation
      if (messages.value.isNotEmpty &&
          (conversationId == null ||
              (conversationId != null &&
                  conversationId.toString().startsWith('temp-')))) {
        isCreatingConversation.value = true;
      }
      // If we now have a real conversation ID, we're done creating
      else if (conversationId != null &&
          !conversationId.toString().startsWith('temp-')) {
        isCreatingConversation.value = false;
      }

      return null;
    }, [conversationId, messages.value]);

    // Handlers
    void handleSelectQuestion(String selectedQuestion) {
      question.value = selectedQuestion;
    }

    void sendQuestion(Map<String, dynamic> message) {
      // Add new message to the beginning of the list (optimistic update)
      messages.value = [
        message,
        ...messages.value,
      ];

      // If this is our first message, mark that we're creating a conversation
      if (conversationId == null ||
          conversationId.toString().startsWith('temp-')) {
        isCreatingConversation.value = true;
      }

      // Clear the selected question if one was used
      if (question.value != null) {
        question.value = null;
      }

      FocusScope.of(context).unfocus();
    }

    void handleCloseDrawer() {
      scaffoldKey.currentState?.closeEndDrawer();
    }

    // Build the main content based on the current state
    Widget buildMainContent() {
      // Show loading indicator only when fetching existing messages
      // Don't show when we're creating a new conversation
      if (conversationId != null &&
          !conversationId.toString().startsWith('temp-') &&
          !isNewConversation &&
          isLoading.value &&
          !isCreatingConversation.value) {
        return Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF12A5BC),
            backgroundColor: const Color(0xFF323232).withOpacity(0.1),
          ),
        );
      }

      // Always show messages when we have them, regardless of conversation state
      if (messages.value.isNotEmpty) {
        return MessageList(messages: messages.value);
      }

      // For established but empty conversations
      if (conversationId != null &&
          !conversationId.toString().startsWith('temp-') &&
          !isNewConversation &&
          !isCreatingConversation.value) {
        return const Center(child: Text("No messages yet"));
      }

      return Container(
        alignment: Alignment.center,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 280,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/webp/full_float.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const GradientText(
                  "Hey there, I'm Giga!",
                  style: TextStyle(
                    fontSize: 29,
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
                  width: 270,
                  child: Text(
                    "Got questions? Ask away, and I'll do my best to help you out!",
                    textAlign: TextAlign.center,
                    style: styleText(
                      context: context,
                      fontSizeOption: 12.0,
                      lineHeightOption: LineHeightOption.height200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Determine whether to show the questions widget
    bool shouldShowQuestions() {
      return question.value == null &&
          messages.value.isEmpty &&
          conversationId == null &&
          !isCreatingConversation.value &&
          !isGeneratingResponse;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          debugPrint("Pop invoked with result: ${extras['prev']}");
          bottomNavProvider.setIndex(index: extras['prev'] ?? 0);
          // context.read<ConversationProvider>().resetConversation();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          shadowColor: const Color(0xFF323232).withOpacity(0.2),
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () async {
              final hasVisited = storage.getData(key: "visited-chat");
              FocusScope.of(context).unfocus();

              if (context.mounted) {
                bottomNavProvider.setIndex(index: extras['prev']);
                context.go(hasVisited == true ? extras['path'] : "/chat");
              }
            },
            icon: const Icon(Icons.arrow_back_ios_sharp),
          ),
          actions: !isGuest
              ? [
                  IconButton(
                    onPressed: () {
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 27,
                    ),
                  ),
                ]
              : [],
          title: Text("Giga", style: Theme.of(context).textTheme.headlineSmall),
          centerTitle: true,
        ),
        onDrawerChanged: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        endDrawer: !isGuest
            ? MessageDrawer(handleCloseDrawer: handleCloseDrawer)
            : null,
        body: SafeArea(
          child: Column(
            children: [
              // Main content area
              Expanded(
                child: buildMainContent(),
              ),

              if (isGeneratingResponse)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'lib/assets/webp/head_type.gif',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

              shouldShowQuestions()
                  ? Questions(handleSelectQuestion: handleSelectQuestion)
                  : const SizedBox.shrink(),

              MessageInput(
                question: question.value,
                handleSendQuestion: sendQuestion,
                handleSelectQuestion: handleSelectQuestion
              ),
            ],
          ),
        ),
      ),
    );
  }
}
