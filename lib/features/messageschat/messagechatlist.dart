import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/messageschat/listmessages.dart';
import 'package:guideurself/features/messageschat/messagechatinput.dart';
import 'package:guideurself/providers/messagechat.dart';
import 'package:guideurself/services/messagechats.dart';
import 'package:guideurself/services/socket.dart';
import 'package:provider/provider.dart';

class MessageChatList extends HookWidget {
  const MessageChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = useRef(SocketService());
    final messageChatProvider = context.read<MessageChatProvider>();
    final receiver = messageChatProvider.message;
    final messages = useState<List<dynamic>>([]);
    final isLoading = useState(true);
    final isError = useState(false);
    final isMounted = useRef(true); // ✅ Track mounted state manually

    void fetchMessages() async {
      if (receiver['_id'] == null || receiver['_id'].toString().isEmpty) return;

      isLoading.value = true;
      isError.value = false;

      try {
        final fetchedMessages = await getMessages(receiver['_id']);

        if (isMounted.value) {
          // ✅ Ensure widget is still mounted
          messages.value = fetchedMessages;
        }
      } catch (error) {
        if (isMounted.value) {
          isError.value = true;
        }
        debugPrint("Error fetching messages: $error");
      } finally {
        if (isMounted.value) {
          isLoading.value = false;
        }
      }
    }

    useEffect(() {
      isMounted.value = true; // ✅ Set to true when mounted

      final receiverId = receiver['_id']?.toString();
      if (receiverId == null || receiverId.isEmpty) return null;

      socketService.value.joinRoom(receiverId);
      fetchMessages();

      void onNewMessage(dynamic newMessage) {
        if (isMounted.value) {
          // ✅ Prevent updating after unmounting
          messages.value = [newMessage, ...messages.value];
        }
      }

      socketService.value.listenForMessages(onNewMessage);

      return () {
        isMounted.value = false; // ✅ Mark unmounted to prevent state updates
        socketService.value.socket
            .off("receiveMessage", onNewMessage); // ✅ Proper cleanup
      };
    }, [receiver['_id']]);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            messageChatProvider.resetMessage();
            context.go("/messages-chat");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: receiver["user_profile"] != null
                  ? NetworkImage(receiver["user_profile"])
                  : null,
              child: receiver["user_profile"] == null
                  ? const Icon(Icons.person, size: 15)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              receiver["name"] ?? "Unknown",
              style: styleText(
                context: context,
                fontSizeOption: 14.0,
                fontWeight: CustomFontWeight.weight500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF12A5BC),
                      backgroundColor: const Color(0xFF323232).withOpacity(0.1),
                    ),
                  )
                : isError.value
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Error fetching messages"),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: fetchMessages,
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : messages.value.isEmpty
                        ? const Center(child: Text("No messages yet"))
                        : ListMessages(messages: messages.value),
          ),
          const MessageChatInput(),
        ],
      ),
    );
  }
}
