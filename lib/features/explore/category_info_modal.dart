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
              decoration: BoxDecoration(
                color: iconColor.withOpacity(
                    0.3), // Adjust this value between 0.0 (transparent) and 1.0 (opaque)
                shape: BoxShape.circle,
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
              style: const TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
