import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Meet, Giga!",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [boxShadow],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Image(
                          image: AssetImage('lib/assets/images/LOGO-md.png'),
                        ),
                      ),
                      const Gap(5),
                      Text(
                        "Hello! I'm Giga, your GuideURSelf assistant!",
                        style: styleText(
                            context: context,
                            fontSizeOption: FontSizeOption.size100,
                            lineHeightOption: LineHeightOption.height200,
                            fontWeight: CustomFontWeight.weight700),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(10),
                      Text(
                        "As part of the URS Giants family, I’m here to help you navigate all things URS, from campus information to support with university processes. Whether you’re looking for answers, need directions, or just have a question about university life, I’m your go-to guide!",
                        style: styleText(
                            context: context,
                            fontSizeOption: FontSizeOption.size100,
                            lineHeightOption: LineHeightOption.height200),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(14),
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Just ask, ang let's make your URS experience giant-sized!",
                          style: styleText(
                              context: context,
                              fontSizeOption: FontSizeOption.size100,
                              lineHeightOption: LineHeightOption.height200,
                              fontWeight: CustomFontWeight.weight600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go("/chatbot");
                          },
                          style: Theme.of(context).elevatedButtonTheme.style,
                          child: const Text(
                            "Continue",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
