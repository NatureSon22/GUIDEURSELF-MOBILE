import 'package:flutter/material.dart';
import 'package:guideurself/core/themes/style.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: const Color(0xFF323232).withOpacity(0.1), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
            },
            child: const Icon(Icons.menu),
          ),
          Text(
            'History',
            style: styleText(
                context: context,
                fontSizeOption: FontSizeOption.size300,
                lineHeightOption: LineHeightOption.height100),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
