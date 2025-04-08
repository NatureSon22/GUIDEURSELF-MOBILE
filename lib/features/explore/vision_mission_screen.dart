import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';
import 'package:go_router/go_router.dart';

class VisionMissionScreen extends StatefulWidget {
  const VisionMissionScreen({super.key});

  @override
  _VisionMissionScreenState createState() => _VisionMissionScreenState();
}

class _VisionMissionScreenState extends State<VisionMissionScreen> {
  late Future<UniversityManagement> _universityFuture;

  @override
  void initState() {
    super.initState();
    _universityFuture = fetchUniversityDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go("/explore");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/background-img.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.2, -1),
                ),
              ),
            ),
          ),
          FutureBuilder<UniversityManagement>(
            future: _universityFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: const Color(0xFF12A5BC),
                  backgroundColor: const Color(0xFF323232).withOpacity(0.1),
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No data found"));
              } else {
                final university = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (snapshot.data!.universityVectorUrl != null)
                                Image.network(
                                  snapshot.data!.universityVectorUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                        Icons.image_not_supported);
                                  },
                                ),
                              const SizedBox(width: 4),
                              if (snapshot.data!.universityLogoUrl != null)
                                Image.network(
                                  snapshot.data!.universityLogoUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                        Icons.image_not_supported);
                                  },
                                ),
                            ],
                          ),
                        ),
                        const Text(
                          'University Of Rizal System',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Cinzel",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const Text(
                          "Nurturing Tomorrow's Noblest",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "CinzelDecorative",
                              fontSize: 12,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        if (university.universityVision != null)
                          _buildHtmlSection("", university.universityVision!),
                        if (university.universityMission != null)
                          _buildHtmlSection("", university.universityMission!),
                        if (university.universityCoreValues != null)
                          _buildHtmlSection(
                              "", university.universityCoreValues!),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlSection(String title, String htmlContent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3), // Semi-transparent background

          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(255, 235, 235, 235),
            width: 1,
          ), // Optional: rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Html(
              data: _removeBrTagsAndStyleStrong(htmlContent),
              style: {
                "body": Style(
                  textAlign: TextAlign.center,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  String _removeBrTagsAndStyleStrong(String htmlContent) {
    var document = html_parser.parse(htmlContent);
    document.querySelectorAll('br').forEach((br) => br.remove());
    document.querySelectorAll('strong').forEach((strong) {
      strong.attributes['style'] = 'font-size: 20px; font-family: CinzelDecorative;';
    });
    return document.body?.innerHtml ?? htmlContent;
  }
}
