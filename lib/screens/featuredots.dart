import 'package:flutter/material.dart';

class FeatureDots extends StatelessWidget {
  final int index;
  const FeatureDots({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (dotIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == dotIndex ? const Color(0xFF12A5BC) : Colors.grey.shade200,
          ),
        );
      }),
    );
  }
}
