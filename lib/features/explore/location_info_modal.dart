import 'package:flutter/material.dart';

class LocationInfoModal extends StatelessWidget {
  final String description;

  const LocationInfoModal({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/webp/head_idle3.gif',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 150, // Fixed height for the text container
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}