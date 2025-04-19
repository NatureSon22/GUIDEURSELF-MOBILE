import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/messagereview.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

final Map<String, String> reasonValue = {
  "notFactuallyCorrect": 'The information is not accurate or reliable',
  "didntFollowInstructions": 'The response did not follow the instructions',
  "offensiveOrUnsafe": 'The response contains offensive or harmful content',
  "other": 'Other'
};

class MessageBubble extends StatelessWidget {
  final bool? initialIsHelpful;
  const MessageBubble({
    super.key,
    required this.messageId,
    required this.content,
    required this.isMachine,
    required this.isFailed,
    required this.showDislikeReason,
    this.initialIsHelpful,
  });

  final String messageId;
  final String content;
  final bool isMachine;
  final bool isFailed;
  final Future<Map<String, dynamic>?> Function(BuildContext) showDislikeReason;

  Future<void> handleReview(BuildContext context, bool helpful) async {
    final provider = context.read<MessageReviewProvider>();

    if (helpful) {
      await provider.setReviewState(messageId, helpful);
    } else {
      final reason = await showDislikeReason(context);
      final value = reason?["reason"] ?? reason?["customReason"];
      await provider.setReviewState(messageId, helpful, reason: value);
    }

    if (context.mounted) {
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
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: content));

    if (context.mounted) {
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
    final String contentLower = content.toLowerCase();
    final bool showChatButton = isMachine &&
        (contentLower.contains("couldn't find a direct answer") ||
            contentLower.contains("for university-related questions") ||
            contentLower.contains("please check official resources") ||
            contentLower.contains("refine your query")) &&
        !isGuest;
    final reviewProvider = context.watch<MessageReviewProvider>();
    var reviewState = reviewProvider.getReviewState(messageId);
    if (reviewState == null && initialIsHelpful != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reviewProvider.reviewStates[messageId] = initialIsHelpful;
      });
      reviewState = initialIsHelpful;
    }

    return Align(
      alignment: isMachine ? Alignment.centerLeft : Alignment.centerRight,
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
              margin: EdgeInsets.symmetric(vertical: isMachine ? 10 : 15),
              decoration: BoxDecoration(
                color: isMachine
                    ? isFailed
                        ? const Color.fromRGBO(239, 68, 68, 0.1)
                        : const Color(0xFF12A5BC).withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: isMachine
                      ? isFailed
                          ? const Color.fromRGBO(239, 68, 68, 1)
                          : const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                  width: 1.3,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMachine ? 0 : 20),
                  bottomRight: Radius.circular(isMachine ? 20 : 0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return MarkdownBody(
                        data: content.replaceAll('MOBILE:', ''),
                        shrinkWrap: true,
                        fitContent: true,
                        styleSheet: MarkdownStyleSheet(
                          h1: styleText(
                              context: context,
                              fontSizeOption: 13.0,
                              color: const Color(0xFF323232)),
                          h2: styleText(
                              context: context,
                              fontSizeOption: 12.0,
                              color: const Color(0xFF323232)),
                          h3: styleText(
                              context: context,
                              fontSizeOption: 12.0,
                              color: const Color(0xFF323232)),
                          h4: styleText(
                              context: context,
                              fontSizeOption: 12.0,
                              color: const Color(0xFF323232)),
                          p: styleText(
                              context: context,
                              fontSizeOption: 11.5,
                              color: const Color(0xFF323232)),
                          listBullet: styleText(
                              context: context,
                              fontSizeOption: 11.5,
                              color: const Color(0xFF323232)),
                          tableBody: const TextStyle(
                              fontSize: 11, color: Color(0xFF323232)),
                          blockSpacing: 8.0,
                          h1Padding:
                              const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          h2Padding:
                              const EdgeInsets.only(top: 12.0, bottom: 6.0),
                          h3Padding:
                              const EdgeInsets.only(top: 8.0, bottom: 4.0),
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
                  if (showChatButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push("/messages-chat");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF12A5BC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Contact University',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isMachine && !isFailed)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _copyToClipboard(context),
                      child: Icon(Icons.copy_all_outlined,
                          size: 18, color: iconColor),
                    ),
                    const Gap(17),
                    if (reviewState == true)
                      Icon(Icons.thumb_up_alt_rounded,
                          size: 18, color: iconColor)
                    else if (reviewState == false)
                      Icon(Icons.thumb_down_alt_rounded,
                          size: 18, color: iconColor)
                    else if (!isGuest) ...[
                      GestureDetector(
                        onTap: () => handleReview(context, true),
                        child: Icon(Icons.thumb_up_off_alt_outlined,
                            size: 18, color: iconColor),
                      ),
                      const Gap(17),
                      GestureDetector(
                        onTap: () => handleReview(context, false),
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
