import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.messageId,
    required this.content,
    required this.isMachine,
    required this.isFailed,
    this.initialIsHelpful,
  });

  final String messageId;
  final String content;
  final bool isMachine;
  final bool isFailed;
  final bool? initialIsHelpful;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool? isHelpful;

  @override
  void initState() {
    super.initState();
    isHelpful = widget.initialIsHelpful;
  }

  bool get isReviewed => isHelpful != null;

  Future<void> handleReview(bool helpful) async {
    final previousState = isHelpful;
    setState(() {
      isHelpful = helpful;
    });

    try {
      await reviewIsHelpful(messageId: widget.messageId, isHelpful: helpful);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Feedback submitted!",
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
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isHelpful = previousState;
      });
    }
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.content));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Copied to clipboard!",
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
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = const Color(0xFF323232).withOpacity(0.7);
    final accountProvider = context.read<AccountProvider>();
    final account = accountProvider.account;
    final isGuest = account.isEmpty;

    return Align(
      alignment:
          widget.isMachine ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin:
                  EdgeInsets.symmetric(vertical: widget.isMachine ? 10 : 15),
              decoration: BoxDecoration(
                color: widget.isMachine
                    ? widget.isFailed
                        ? const Color.fromRGBO(239, 68, 68, 0.1)
                        : const Color(0xFF12A5BC).withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: widget.isMachine
                      ? widget.isFailed
                          ? const Color.fromRGBO(239, 68, 68, 1)
                          : const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                  width: 1.3,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(widget.isMachine ? 0 : 20),
                  bottomRight: Radius.circular(widget.isMachine ? 20 : 0),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return MarkdownBody(
                    data: widget.content,
                    shrinkWrap: true,
                    fitContent: true,
                    styleSheet: MarkdownStyleSheet(
                      // Heading styles
                      h1: styleText(
                        context: context,
                        fontSizeOption: 13.5,
                        color: const Color(0xFF323232),
                      ),
                      h2: styleText(
                        context: context,
                        fontSizeOption: 12.0,
                        color: const Color(0xFF323232),
                      ),
                      h3: styleText(
                        context: context,
                        fontSizeOption: 12.0,
                        color: const Color(0xFF323232),
                      ),
                      // Paragraph styles
                      p: styleText(
                        context: context,
                        fontSizeOption: 11.5,
                        color: const Color(0xFF323232),
                      ),
                      // List styles
                      listBullet: styleText(
                        context: context,
                        fontSizeOption: 11.5,
                        color: const Color(0xFF323232),
                      ),
                      tableBody: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF323232),
                      ),
                      // Spacing
                      blockSpacing: 8.0,
                      h1Padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      h2Padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
                      h3Padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      pPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      listIndent: 20.0,
                      listBulletPadding: const EdgeInsets.only(right: 4),
                      tableCellsPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      tableColumnWidth: const FlexColumnWidth(),
                    ),
                  );
                },
              ),
            ),
            if (widget.isMachine && !widget.isFailed)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _copyToClipboard,
                      child: Icon(Icons.copy_all_outlined,
                          size: 18, color: iconColor),
                    ),
                    const Gap(17),
                    if (isHelpful == true)
                      Icon(Icons.thumb_up_alt_rounded,
                          size: 18, color: iconColor)
                    else if (isHelpful == false)
                      Icon(Icons.thumb_down_alt_rounded,
                          size: 18, color: iconColor)
                    else if (!isGuest) ...[
                      GestureDetector(
                        onTap: () => handleReview(true),
                        child: Icon(Icons.thumb_up_off_alt_outlined,
                            size: 18, color: iconColor),
                      ),
                      const Gap(17),
                      GestureDetector(
                        onTap: () => handleReview(false),
                        child: Icon(Icons.thumb_down_alt_outlined,
                            size: 18, color: iconColor),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
