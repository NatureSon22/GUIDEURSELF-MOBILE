import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/services/conversation.dart';

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
    print("MessageBubble: isHelpful: $isHelpful");
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
              child: HtmlWidget(
                widget.content,
                textStyle: const TextStyle(
                  color: Color(0xFF323232),
                  fontSize: 12,
                ),
                customStylesBuilder: (element) {
                  const headingTags = {'h1', 'h2', 'h3'};
                  if (headingTags.contains(element.localName)) {
                    return {'line-height': '1.4', 'font-size': '14px'};
                  }
                  return null;
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
                      Icon(
                        Icons.thumb_up_alt_rounded,
                        size: 18,
                        color: iconColor,
                      )
                    else if (isHelpful == false)
                      Icon(
                        Icons.thumb_down_alt_rounded,
                        size: 18,
                        color: iconColor,
                      )
                    else ...[
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
