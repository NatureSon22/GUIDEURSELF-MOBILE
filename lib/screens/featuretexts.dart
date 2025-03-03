import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

List<Map<String, String>> featureTexts = [
  {
    "label": "Your Virtual Guide, Ready to Assist!",
    "highlight": "Virtual Guide",
    "description":
        "Get instant answers about enrollment, campus services, and university processes with our AI-powered chatbot."
  },
  {
    "label": "Shoot, Take a Panorama!",
    "highlight": "Panorama!",
    "description":
        "Explore stunning panoramic shots of the university, giving you a full view of key locations anytime, anywhere"
  },
  {
    "label": "University Services at Your Fingertips",
    "highlight": "Services at Your Fingertips",
    "description":
        "Enjoy a seamless campus experience with fast access to information, all from your mobile device."
  },
  {
    "label": "Navigate Your Campus with Ease",
    "highlight": "Campus",
    "description":
        "Find offices, classrooms, and facilities effortlessly with our built-in campus navigation tool."
  }
];

class FeatureTexts extends StatelessWidget {
  final int index;
  const FeatureTexts({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final featureText = featureTexts[index];
    final label = featureText["label"]!;
    final highlight = featureText["highlight"]!;

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: _buildStyledLabel(label, highlight),
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF323232),
            ),
          ),
        ),
        const Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Text(
            featureText["description"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Color(0xFF323232),
                height: 2),
          ),
        ),
      ],
    );
  }

  List<TextSpan> _buildStyledLabel(String text, String highlight) {
    List<TextSpan> spans = [];
    List<String> parts = text.split(highlight);

    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i]));
      if (i < parts.length - 1) {
        spans.add(TextSpan(
          text: highlight,
          style: const TextStyle(
            color: Color(0xFF12A5BC),
            fontWeight: FontWeight.bold,
          ),
        ));
      }
    }
    return spans;
  }
}
