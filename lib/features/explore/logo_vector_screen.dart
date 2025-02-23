import 'package:flutter/material.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';

class LogoVectorScreen extends StatefulWidget {
  const LogoVectorScreen({super.key});

  @override
  _LogoVectorScreenState createState() => _LogoVectorScreenState();
}

class _LogoVectorScreenState extends State<LogoVectorScreen> {
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
        body: Stack(children: [
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
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
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
                              height: 40), // Space between text and images
                          if (university.universityLogoUrl != null)
                            Column(
                              children: [
                                const Text(
                                  "OFFICIAL LOGO",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Image.network(
                                  university.universityLogoUrl!,
                                  height: 250,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          const SizedBox(
                              height: 30), // Space between logo and vector
                          if (university.universityVectorUrl != null)
                            Column(
                              children: [
                                const Text(
                                  "OFFICIAL VECTOR",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Image.network(
                                  university.universityVectorUrl!,
                                  height: 250,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ]));
  }
}
