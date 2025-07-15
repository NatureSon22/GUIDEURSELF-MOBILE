import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/textscale.dart';
import 'package:provider/provider.dart';

class FeedbackComment extends StatelessWidget {
  final TextEditingController controller;

  const FeedbackComment({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = context.watch<TextScaleProvider>().scaleFactor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF323232).withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tell Us More",
            style: styleText(
              context: context,
              fontWeight: CustomFontWeight.weight600,
              fontSizeOption: 12.0 * textScaleFactor,
            ),
          ),
          const Gap(10),
          TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: 12 * textScaleFactor,
            ),
            decoration: InputDecoration(
              hintText: "What did you like? What could we improve?",
              contentPadding:
                  const EdgeInsets.only(top: 15, left: 10, right: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: const Color(0xFF323232).withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: const Color(0xFF323232).withOpacity(0.45),
                  width: 1.5,
                ),
              ),
            ),
            maxLines: 10,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter your feedback.";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
