import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:provider/provider.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.title,
  });

  final Map<String, dynamic> message;
  final String title;

  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: styleText(
            context: context,
            fontSizeOption: 12.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> handleDeleteChat(BuildContext context) async {
    try {
      await deleteConversation(message["_id"]);
      if (context.mounted) {
        _showSnackBar(context, 'Conversation deleted successfully.', true);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Failed to delete conversation.', false);
      }
    }
  }

  Future<void> _showCustomDialog(BuildContext rootContext) async {
    return showDialog<void>(
      context: rootContext,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Delete chat?',
                  style: styleText(
                    context: rootContext,
                    fontSizeOption: 15.0,
                    fontWeight: CustomFontWeight.weight700,
                  ),
                ),
                Divider(
                  color: const Color(0xFF323232).withOpacity(0.15),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Text(
                    'This will delete $title',
                    style:
                        styleText(context: rootContext, fontSizeOption: 12.0),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        textStyle: const TextStyle(fontSize: 13.5),
                      ),
                      child: const Text('Close'),
                    ),
                    const Gap(10),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await handleDeleteChat(rootContext);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        textStyle: const TextStyle(fontSize: 13.5),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (scaffoldContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromRGBO(239, 68, 68, 1),
                borderRadius: BorderRadius.circular(20)),
            child: Slidable(
              key: Key(message['conversation_id'] ?? title),
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const BehindMotion(),
                children: [
                  CustomSlidableAction(
                    onPressed: (_) {
                      Scaffold.of(scaffoldContext).closeDrawer();
                      _showCustomDialog(scaffoldContext);
                    },
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
                    child: const Icon(
                      Icons.delete,
                      size: 18,
                    ),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF323232).withOpacity(0.1),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.chat_bubble,
                    color: const Color(0xFF323232).withOpacity(0.7),
                    size: 18,
                  ),
                  title: Text(
                    title,
                    style: styleText(context: context, fontSizeOption: 12.0),
                  ),
                  trailing: Transform.rotate(
                    angle: pi,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: const Color(0xFF323232).withOpacity(0.2),
                      size: 18,
                    ),
                  ),
                  onTap: () {
                    context
                        .read<ConversationProvider>()
                        .setConversation(conversation: message);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
