import 'package:flutter/material.dart';

final List<String> featureImages = [
  'lib/assets/webp/Chats.webp',
  'lib/assets/webp/Device.webp',
  'lib/assets/webp/Hand.webp',
  'lib/assets/webp/Papermap.webp',
];

class FeatureImages extends StatefulWidget {
  final int index;
  const FeatureImages({super.key, required this.index});

  @override
  State<FeatureImages> createState() => _FeatureImagesState();
}

class _FeatureImagesState extends State<FeatureImages> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Image.asset(
        featureImages[widget.index],
        key: ValueKey<String>(featureImages[widget.index]),
        fit: BoxFit.cover,
      ),
    );
  }
}
