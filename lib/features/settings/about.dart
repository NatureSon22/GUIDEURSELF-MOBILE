import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:guideurself/providers/textscale.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/widgets/textgradient.dart';
import 'package:provider/provider.dart';
import '../../services/general_settings_service.dart';
import '../../models/general_settings.dart';
import 'package:guideurself/providers/apperance.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late Future<GeneralSettings> _generalFuture;

  @override
  void initState() {
    super.initState();
    _generalFuture = GeneralSettingsService().fetchGeneralSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<AppearanceProvider>().isDarkMode;
    final textScaleFactor = context.watch<TextScaleProvider>().scaleFactor;

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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF323232).withOpacity(0.6),
                ),
              ),
            ),
            const Gap(15),

            // FutureBuilder for fetching data
            FutureBuilder<GeneralSettings>(
              future: _generalFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    snapshot.data!.generalAbout == null) {
                  return const Center(child: Text("No about available."));
                }

                String cleanedHtml =
                    _removeBrTagsAndStyleStrong(snapshot.data!.generalAbout!);

                // Scrollable Content
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 235, 235, 235),
                            width: 1,
                          ),
                        ),
                        child: Html(
                          data: cleanedHtml,
                          style: {
                            "body": Style(
                              textAlign: TextAlign.justify,
                              fontSize: FontSize(12 * textScaleFactor),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GradientText(
                    "Development Team",
                    style: TextStyle(
                      fontSize: 15 * textScaleFactor,
                      fontWeight: FontWeight.w700,
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF12A5BC),
                        Color(0xFF0E46A3),
                      ],
                    ),
                  ),
                  const Gap(3),
                  Text(
                    "Eryn Breanne B. Alva",
                    style: styleText(
                      context: context,
                      fontSizeOption: 11.0 * textScaleFactor,
                    ),
                  ),
                  Text(
                    "Jio T. Banta",
                    style: styleText(
                      context: context,
                      fontSizeOption: 11.0 * textScaleFactor,
                    ),
                  ),
                  Text(
                    "John Irish E. Corrales",
                    style: styleText(
                      context: context,
                      fontSizeOption: 11.0 * textScaleFactor,
                    ),
                  ),
                  Text(
                    "Kenneth J. San Pedro",
                    style: styleText(
                      context: context,
                      fontSizeOption: 11.0 * textScaleFactor,
                    ),
                  ),
                  Text(
                    "Paulen V. Vitor",
                    style: styleText(
                      context: context,
                      fontSizeOption: 11.0 * textScaleFactor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Cleans up HTML content: removes `<br>` tags and styles `<strong>` elements
  String _removeBrTagsAndStyleStrong(String htmlContent) {
    var document = html_parser.parse(htmlContent);
    document.querySelectorAll('br').forEach((br) => br.remove());
    return document.body?.innerHtml ?? htmlContent;
  }
}
