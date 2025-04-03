import 'package:flutter/material.dart';

class GifTestScreen extends StatelessWidget {
  const GifTestScreen({super.key}); // Add a constructor with a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIF Test'), // Updated title
      ),
      body: Center(
        child: Image.asset(
          'lib/assets/lottie/full_intro.gif', // Path to your GIF file
          width: 300,
          height: 300,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame == null) {
              return CircularProgressIndicator(
                color: const Color(0xFF12A5BC),
                backgroundColor: const Color(0xFF323232).withOpacity(0.1),
              ); // Show a loader while the GIF is loading
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error); // Fallback in case of an error
          },
        ),
      ),
    );
  }
}
