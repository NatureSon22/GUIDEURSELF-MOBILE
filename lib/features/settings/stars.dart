import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';

class Stars extends StatefulWidget {
  final bool isFeedbackSubmitted;
  final Function(int) onRatingSelected; // Callback to pass rating

  const Stars(
      {super.key,
      required this.isFeedbackSubmitted,
      required this.onRatingSelected});

  @override
  State<Stars> createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  int selectedRating = 0;

  @override
  void didUpdateWidget(covariant Stars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFeedbackSubmitted &&
        !oldWidget.isFeedbackSubmitted &&
        widget.isFeedbackSubmitted == true) {
      setState(() {
        selectedRating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate Your Experience",
          style: styleText(
            context: context,
            fontWeight: CustomFontWeight.weight600,
            fontSizeOption: 12.0,
          ),
        ),
        const Gap(10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF323232).withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                    widget.onRatingSelected(selectedRating);
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    size: 30,
                    color: index < selectedRating
                        ? const Color(0xFF12A5BC)
                        : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
