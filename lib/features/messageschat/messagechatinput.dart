import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/messagechat.dart';
import 'package:guideurself/services/socket.dart';
import 'package:provider/provider.dart';

class MessageChatInput extends HookWidget {
  const MessageChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = useMemoized(() => SocketService(), []);
    final accountProvider = context.read<AccountProvider>();
    final messageChatProvider = context.read<MessageChatProvider>();
    final sender = accountProvider.account;
    final receiver = messageChatProvider.message;
    final controller = useTextEditingController();

    void handleSendMessage() {
      if (controller.text.trim().isEmpty) return;

      if (!socketService.socket.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Connection lost. Please check your internet connection.",
              style: styleText(
                context: context,
                fontSizeOption: 12.0,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF323232),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        return;
      }

      socketService.sendMessage(
          senderId: sender['_id'],
          receiverId: receiver['_id'],
          content: controller.text.trim(),
          files: []);
      controller.clear();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
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
              debugPrint("Attach file button pressed");
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
            child: const Icon(Icons.attach_file, size: 20),
          ),
          const Gap(4),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 12),
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
            onPressed: handleSendMessage,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(11),
            ),
            child: Transform.rotate(
              angle: -0.785398, // Rotates the send icon
              child: const Icon(Icons.send, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
