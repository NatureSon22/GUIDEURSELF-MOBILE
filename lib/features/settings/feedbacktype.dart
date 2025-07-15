import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/constants/projecttype.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/textscale.dart';
import 'package:provider/provider.dart';

class FeedbackType extends StatefulWidget {
  final ProjectType feedbackType;
  final Function(ProjectType type) selectFeedbackType;
  const FeedbackType(
      {super.key,
      required this.feedbackType,
      required this.selectFeedbackType});

  @override
  State<FeedbackType> createState() => _FeedbackTypeState();
}

class _FeedbackTypeState extends State<FeedbackType> {
  @override
  Widget build(BuildContext context) {
    final textScaleFactor = context.watch<TextScaleProvider>().scaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What’s this feedback about?",
          style: styleText(
            context: context,
            fontWeight: CustomFontWeight.weight600,
            fontSizeOption: 12.0 * textScaleFactor,
          ),
        ),
        const Gap(10),
        Row(
          children: ProjectType.values.asMap().entries.map((entry) {
            final index = entry.key;
            final type = entry.value;
            final isChosen = type == widget.feedbackType;

            BorderRadius borderRadius = BorderRadius.zero;
            Border border = Border.all(
              color: const Color(0xFF323232).withOpacity(0.1),
            );

            if (index == 0) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              );
              border = Border(
                top: BorderSide(
                  color: isChosen
                      ? const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                ),
                left: BorderSide(
                  color: isChosen
                      ? const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                ),
                bottom: BorderSide(
                  color: isChosen
                      ? const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                ),
              );
            } else if (index == 2) {
              borderRadius = const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              );
              border = Border(
                top: BorderSide(
                  color: isChosen
                      ? const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                ),
                right: BorderSide(
                  color: isChosen
                      ? const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                ),
                bottom: BorderSide(
                  color: isChosen
                      ? const Color(0xFF12A5BC)
                      : const Color(0xFF323232).withOpacity(0.1),
                ),
              );
            }

            return Expanded(
                child: GestureDetector(
              onTap: () {
                widget.selectFeedbackType(type);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: border,
                  borderRadius: borderRadius,
                  color: isChosen ? const Color(0xFF12A5BC) : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  type.name,
                  style: TextStyle(
                    fontSize: 10 * textScaleFactor,
                    fontWeight: isChosen ? FontWeight.w700 : FontWeight.normal,
                    color: isChosen ? Colors.white : const Color(0xFF323232),
                  ),
                ),
              ),
            ));
          }).toList(),
        )
      ],
    );
  }
}
