import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<UniversityManagement> _universityFuture;

  @override
  void initState() {
    super.initState();
    _universityFuture = fetchUniversityDetails(); // Fetch university details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          // Background Image
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
          // FutureBuilder for fetching data
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
                          // Use Image.network for the vector URL from the database
                          if (snapshot.data!.universityVectorUrl != null)
                            Image.network(
                              snapshot.data!.universityVectorUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons
                                    .image_not_supported); // Fallback if image fails to load
                              },
                            ),
                          const SizedBox(width: 4),
                          // Use Image.network for the logo URL from the database
                          if (snapshot.data!.universityLogoUrl != null)
                            Image.network(
                              snapshot.data!.universityLogoUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons
                                    .image_not_supported); // Fallback if image fails to load
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

                    // HTML Content
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.3), // Semi-transparent background

                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 235, 235, 235),
                          width: 1,
                        ), // Optional: rounded corners
                      ),
                      child: Html(
                        data: cleanedHtml,
                        style: {
                          "body": Style(
                            textAlign: TextAlign.center,
                          ),
                        },
                      ),
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

  /// Cleans up HTML content: removes `<br>` tags and styles `<strong>` elements
  String _removeBrTagsAndStyleStrong(String htmlContent) {
    var document = html_parser.parse(htmlContent);
    document.querySelectorAll('br').forEach((br) => br.remove());
    document.querySelectorAll('strong').forEach((strong) {
      strong.attributes['style'] = 'font-size: 20px; font-family: CinzelDecorative;';
    });
    return document.body?.innerHtml ?? htmlContent;
  }
}
