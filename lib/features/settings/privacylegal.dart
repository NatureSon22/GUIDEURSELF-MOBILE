import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/services/setttings.dart';
import 'package:shimmer/shimmer.dart';

class PrivacyLegal extends StatefulWidget {
  const PrivacyLegal({super.key});

  @override
  State<PrivacyLegal> createState() => _PrivacyLegalState();
}

class _PrivacyLegalState extends State<PrivacyLegal> {
  late Future<Map<String, String>> _futurePrivacyAndLegal;

  @override
  void initState() {
    super.initState();
    _futurePrivacyAndLegal = getPrivacyAndLegal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Privacy and Legal",
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
        child: FutureBuilder<Map<String, String>>(
          future: _futurePrivacyAndLegal,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerText(width: 180, height: 30),
                  const Gap(20),
                  SizedBox(
                    height: 250,
                    child: _buildShimmerBox(),
                  ),
                  const Gap(20),
                  _buildShimmerText(width: 180, height: 30),
                  const Gap(20),
                  SizedBox(
                    height: 250,
                    child: _buildShimmerBox(),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Failed to fetch data"),
                    const Gap(10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futurePrivacyAndLegal = getPrivacyAndLegal();
                        });
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;
            final privacyPolicy =
                data["privacyPolicy"] ?? "No privacy policy available.";
            final termsAndConditions = data["termsAndConditions"] ??
                "No terms and conditions available.";

            String formattedText(String text) => text
                .replaceAll(RegExp(r'<br\s*/?>'), '') // Remove <br> tags
                .replaceAllMapped(
                    RegExp(r'<h[1-6]>\s*<strong>(.*?)</strong>\s*</h[1-6]>',
                        dotAll: true),
                    (match) => '<p>${match.group(1)?.trim()}</p>')
                .replaceAllMapped(
                    RegExp(r'<strong[^>]*>(.*?)</strong>', dotAll: true),
                    (match) => '<p>${match.group(1)}</p>')
                .replaceAll(RegExp(r'<p>\s*</p>'), '')
                .replaceAll(RegExp(r'class="[^"]*"'), '')
                .replaceAll(RegExp(r'<h[1-6][^>]*>|</h[1-6]>'), '');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Privacy Policy",
                  style: styleText(
                    context: context,
                    fontSizeOption: 14.0,
                    fontWeight: CustomFontWeight.weight600,
                  ),
                ),
                const Gap(10),
                HtmlWidget(
                  formattedText(privacyPolicy),
                  textStyle: styleText(
                    context: context,
                    fontSizeOption: 12.0,
                  ),
                ),
                const Gap(40),
                Text(
                  "Terms and Conditions",
                  style: styleText(
                    context: context,
                    fontSizeOption: 14.0,
                    fontWeight: CustomFontWeight.weight600,
                  ),
                ),
                const Gap(10),
                HtmlWidget(
                  formattedText(termsAndConditions),
                  textStyle: styleText(
                    context: context,
                    fontSizeOption: 12.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Function to create a shimmer text effect
  Widget _buildShimmerText(
      {double width = double.infinity, double height = 14}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  // Function to create a shimmer box effect
  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
