import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
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
  bool?
      isHelpful; // null -> Not reviewed, true -> Helpful, false -> Not helpful

  @override
  void initState() {
    super.initState();
    isHelpful = widget.initialIsHelpful;
  }

  bool get isReviewed => isHelpful != null;

  Future<void> handleReview(bool helpful) async {
    setState(() {
      isHelpful = helpful;
    });

    try {
      await reviewIsHelpful(
        messageId: widget.messageId,
        isHelpful: helpful,
      );
    } catch (e) {
      // Optional: Show error and revert state if API call fails
      setState(() {
        isHelpful = null; // Revert if failed
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.isMachine ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, 
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
                  if (element.localName == 'h1' ||
                      element.localName == 'h2' ||
                      element.localName == 'h3') {
                    return {'line-height': '1.4', 'font-size': '14px'};
                  }
                  return null;
                },
              ),
            ),
            if (widget.isMachine)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.copy_all_outlined,
                      size: 18,
                      color: const Color(0xFF323232).withOpacity(0.7),
                    ),
                    const Gap(17),
                    Icon(
                      Icons.note_add_outlined,
                      size: 18,
                      color: const Color(0xFF323232).withOpacity(0.7),
                    ),
                    const Gap(17),
                    if (isReviewed)
                      Icon(
                        isHelpful == true
                            ? Icons.thumb_up_alt_rounded
                            : Icons.thumb_down_alt_rounded,
                        size: 18,
                        color: const Color(0xFF323232).withOpacity(0.7),
                      )
                    else ...[
                      GestureDetector(
                        onTap: () => handleReview(true),
                        child: Icon(
                          Icons.thumb_up_off_alt_outlined,
                          size: 18,
                          color: const Color(0xFF323232).withOpacity(0.7),
                        ),
                      ),
                      const Gap(17),
                      GestureDetector(
                        onTap: () => handleReview(false),
                        child: Icon(
                          Icons.thumb_down_alt_outlined,
                          size: 18,
                          color: const Color(0xFF323232).withOpacity(0.7),
                        ),
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
