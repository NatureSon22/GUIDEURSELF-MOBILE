import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final account = accountProvider.account;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: account["user_photo_url"] != null &&
                          account["user_photo_url"].isNotEmpty
                      ? NetworkImage(account["user_photo_url"])
                      : const AssetImage("lib/assets/images/avatar_placeholder.png")
                          as ImageProvider,
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
                  account["username"] ??
                      "Guest", // Use name from account or "Guest"
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
