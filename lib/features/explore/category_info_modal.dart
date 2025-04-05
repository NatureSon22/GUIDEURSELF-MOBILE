import 'package:flutter/material.dart';

class CategoryInfoModal extends StatelessWidget {
  final IconData icon;
  final String category;
  final String description;
  final Color iconColor;

  const CategoryInfoModal({
    Key? key,
    required this.icon,
    required this.category,
    required this.description,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90, // Width of the container
              height:
                  90, // Height of the container (same as width to make it a circle)
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 235, 235, 235), // Set the background color to gray
                shape: BoxShape.circle, // Make the container circular
              ),
              child: Icon(
                icon, // Pass the icon here
                size: 50, // Icon size
                color: iconColor, // Icon color
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category,
              style: TextStyle(
                fontSize: 18,
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
