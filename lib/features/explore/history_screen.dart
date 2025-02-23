import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final UniversityManagementService _service = UniversityManagementService();
  late Future<UniversityManagement> _universityFuture;

  @override
  void initState() {
    super.initState();
    _universityFuture = _service.fetchUniversityDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Ensure the background is white
        elevation: 0, // Remove default elevation
        scrolledUnderElevation: 0, // Disable elevation
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: 0.3,
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
          // FutureBuilder for fetching data
          FutureBuilder<UniversityManagement>(
            future: _universityFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData ||
                  snapshot.data!.universityHistory == null) {
                return const Center(child: Text("No history available."));
              }

              String cleanedHtml = _removeBrTagsAndStyleStrong(
                  snapshot.data!.universityHistory!);

              // Scrollable Content
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header with Images and Text
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/assets/images/UrsVector.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 2),
                          Image.asset(
                            'lib/assets/images/UrsLogo.png',
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'University Of Rizal System',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Text(
                      "Nurturing Tomorrow's Noblest",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    // HTML Content
                    Html(
                      data: cleanedHtml,
                      style: {
                        "body": Style(
                          textAlign: TextAlign.center, // Center text
                        ),
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Removes `<br>` tags from HTML content
  String _removeBrTagsAndStyleStrong(String htmlContent) {
    // Parse the HTML content
    var document = html_parser.parse(htmlContent);

    // Remove all <br> tags
    document.querySelectorAll('br').forEach((br) => br.remove());

    // Find all <strong> tags and apply custom styling
    document.querySelectorAll('strong').forEach((strong) {
      // Add inline style to set font size to 20px
      strong.attributes['style'] = 'font-size: 20px;';
    });

    // Return the modified HTML content
    return document.body?.innerHtml ?? htmlContent;
  }
}
