import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/settings/feedbackcomment.dart';
import 'package:guideurself/features/settings/stars.dart';

class UserFeedback extends StatelessWidget {
  const UserFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Virtual Tour Preferences",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/FEEDBACK.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(15),
              Text(
                "We Value Your Feedback",
                style: styleText(
                    context: context,
                    fontWeight: CustomFontWeight.weight600,
                    fontSizeOption: 12.0),
              ),
              const Gap(10),
              const Text(
                "Let us know how we're doing to help use improve your GuideURSelf experience",
                style: TextStyle(height: 1.6, fontSize: 11.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  color: const Color(0xFF323232).withOpacity(0.1),
                ),
              ),
              const Stars(),
              const Gap(10),
              const FeedbackComment(),
              const Gap(10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Submit Feedback"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
