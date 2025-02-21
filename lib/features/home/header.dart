import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzrwYBCJ5bXdYy6i-tgg7Pn9lOOp-DDyKIuA&s',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const Gap(1),
                Text(
                  'John Doe',
                  style: styleText(
                    context: context,
                    fontSizeOption: 12.2,
                    color: Colors.white,
                    fontWeight: CustomFontWeight.weight500,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          child: Image.asset(
            'lib/assets/images/URS-Logo.png',
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
