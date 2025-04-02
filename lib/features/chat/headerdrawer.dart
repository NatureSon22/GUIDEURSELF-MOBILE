import 'package:flutter/material.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final conversationProvider = context.watch<ConversationProvider>();

    return Container(
      height: 90,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: const Color(0xFF323232).withOpacity(0.1), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              conversationProvider.resetConversation();
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
            },
            child: const Icon(Icons.create, color: Color(0xFF323232)),
          ),
          Text(
            'History',
            style: styleText(
                context: context,
                fontSizeOption: FontSizeOption.size300,
                lineHeightOption: LineHeightOption.height100),
          ),
          GestureDetector(
            onTap: () {
              context.push("/messages-chat");
            },
            child: const Icon(Icons.person, color: Color(0xFF323232)),
          ),
        ],
      ),
    );
  }
}
