import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/widgets/textgradient.dart';

class About extends StatelessWidget {
  const About({super.key});

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
          "About",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Image(
                image: AssetImage('lib/assets/images/LOGO-md.png'),
              ),
            ),
            const Gap(10),
            Center(
              child: Text(
                "v1.0",
                style: styleText(
                  context: context,
                  fontSizeOption: 14.0,
                  fontWeight: CustomFontWeight.weight600,
                  color: const Color(0xFF323232).withOpacity(0.3),
                ),
              ),
            ),
            const Gap(15),
            Text(
              "GuideURSelf is a mobile-based service desk solution designed specifically for the University of Rizal System (URS). Aiming to streamline information dissemination and enhance campus experiences, GuideURSelf integrates advanced chatbot technology and immersive virtual tours to offer users efficient, self-service support. By combining AI-driven responses and interactive navigation, GuideURSelf enables students, faculty, and visitors to access essential campus information and guidance on-the-go, saving time and reducing the need for manual inquiries.",
              textAlign: TextAlign.justify,
              style: styleText(
                context: context,
                fontSizeOption: 12.0,
              ),
            ),
            const Gap(15),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Key Features:",
                style: styleText(
                  context: context,
                  fontSizeOption: 12.0,
                ),
              ),
            ),
            const Gap(5),
            Text(
              "Automated Chatbot: GuideURSelf’s chatbot provides real-time, reliable answers to common questions related to URS processes, making it easier for users to access needed information without waiting.",
              textAlign: TextAlign.justify,
              style: styleText(
                context: context,
                fontSizeOption: 12.0,
              ),
            ),
            const Gap(3),
            Text(
              "Virtual Campus Tours: With virtual tours covering all ten URS campuses, users can explore facilities and locations, improving orientation and navigation.",
              textAlign: TextAlign.justify,
              style: styleText(
                context: context,
                fontSizeOption: 12.0,
              ),
            ),
            const Gap(3),
            Text(
              "User-Focused Design: Designed with students, faculty, and guests in mind, GuideURSelf prioritizes ease of use and accessibility to support diverse needs within the university community.",
              textAlign: TextAlign.justify,
              style: styleText(
                context: context,
                fontSizeOption: 12.0,
              ),
            ),
            const Gap(15),
            Text(
              "GuideURSelf is committed to enhancing URS community interactions by offering a digital platform that is efficient, reliable, and accessible to all users, ensuring a seamless experience in managing campus-related inquiries and navigation.",
              textAlign: TextAlign.justify,
              style: styleText(
                context: context,
                fontSizeOption: 12.0,
              ),
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const GradientText(
                    "Development Team",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF12A5BC),
                        Color(0xFF0E46A3),
                      ],
                    ),
                  ),
                  const Gap(3),
                  Text(
                    "Eryn Breanne B. Alva",
                    style: styleText(context: context, fontSizeOption: 11.0),
                  ),
                  Text(
                    "Jio T. Banta",
                    style: styleText(context: context, fontSizeOption: 11.0),
                  ),
                  Text(
                    "John Irish E. Corrales",
                    style: styleText(context: context, fontSizeOption: 11.0),
                  ),
                  Text(
                    "Kenneth J. San Pedro",
                    style: styleText(context: context, fontSizeOption: 11.0),
                  ),
                  Text(
                    "Paulen V. Vitor",
                    style: styleText(context: context, fontSizeOption: 11.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
