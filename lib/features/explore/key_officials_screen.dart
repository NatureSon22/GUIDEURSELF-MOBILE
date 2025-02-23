import 'package:flutter/material.dart';
import '../../services/key_official_service.dart';
import '../../models/key_official.dart';

class KeyOfficialsScreen extends StatefulWidget {
  const KeyOfficialsScreen({super.key});

  @override
  State<KeyOfficialsScreen> createState() => _KeyOfficialsScreenState();
}

class _KeyOfficialsScreenState extends State<KeyOfficialsScreen> {
  final KeyOfficialService _service = KeyOfficialService();
  late Future<List<KeyOfficial>> _keyOfficialsFuture;

  @override
  void initState() {
    super.initState();
    _keyOfficialsFuture = _service.fetchKeyOfficials();
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
            ),
          ),
          // FutureBuilder to handle data fetching
          FutureBuilder<List<KeyOfficial>>(
            future: _keyOfficialsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No key officials found"));
              }

              List<KeyOfficial> keyOfficials = snapshot.data!;

              // Scrollable Content
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Column(
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
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
                    const SizedBox(height: 8),
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

                    // Key Officials List
                    Column(
                      children: keyOfficials.map((official) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  official.keyOfficialPhotoUrl,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person,
                                          size: 100, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                official.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1.0),
                              Text(
                                official.positionName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
}
