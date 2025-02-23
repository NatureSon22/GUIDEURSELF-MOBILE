import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';

class VisionMissionScreen extends StatefulWidget {
  const VisionMissionScreen({super.key});

  @override
  _VisionMissionScreenState createState() => _VisionMissionScreenState();
}

class _VisionMissionScreenState extends State<VisionMissionScreen> {
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
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
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
            ), // <-- Added missing closing parenthesis here
          ), // <-- Add this closing parenthesis
          // Scrollable Content
          FutureBuilder<UniversityManagement>(
            future: _universityFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Center the column
                      children: [
                        // Header with Images and Text
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/UrsVector.png', // Replace with your image path
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 2), // Space between images
                              Image.asset(
                                'lib/assets/images/UrsLogo.png', // Replace with your image path
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
                        const SizedBox(
                            height: 20), // Space between header and content
                        // Main Content
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the column
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center the title text
              ),
            ),
          Html(
            data: _removeBrTagsAndStyleStrong(htmlContent),
            style: {
              "body": Style(
                textAlign: TextAlign.center, // Center the HTML content
              ),
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
