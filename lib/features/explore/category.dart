import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData getCategoryIcon(String category) {
  switch (category) {
    case "Academic Spaces":
      return Icons.door_front_door; // Door icon
    case "Administrative Offices":
      return Icons.event_seat; // Office chair icon
    case "Student Services":
      return Icons.school; // Graduate hat icon
    case "Campus Attraction":
      return Icons.flag; // Flag icon
    case "Utility Areas":
      return Icons.wc; // Restroom (women/men) icon
    case "Multi-Purpose":
      return Icons.star;
    case "Others (Miscellaneous)":
      return Icons.widgets; // Square plus icon
    default:
      return FontAwesomeIcons.info; // Default unknown icon
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case "Academic Spaces":
      return const Color.fromARGB(255, 243, 240, 33);
    case "Administrative Offices":
      return Colors.red;
    case "Student Services":
      return Colors.blue;
    case "Campus Attraction":
      return Colors.green;
    case "Utility Areas":
      return const Color.fromARGB(255, 255, 91, 200);
    case "Multi-Purpose":
      return Colors.orange;
    case "Others (Miscellaneous)":
      return const Color.fromARGB(255, 169, 21, 214);
    default:
      return const Color.fromARGB(255, 18, 165, 188);
  }
}

String getCategoryDescription(String category) {
  switch (category) {
    case "Academic Spaces":
      return "Areas dedicated to learning, including classrooms, lecture halls, and study zones.";
    case "Administrative Offices":
      return "Offices where faculty and staff manage campus operations and student affairs.";
    case "Student Services":
      return "Facilities that support student needs, such as counseling, career centers, and advisories.";
    case "Campus Attraction":
      return "Key locations that highlight the vibrant and historic aspects of the campus.";
    case "Utility Areas":
      return "Essential service areas, such as restrooms, maintenance rooms, and storage spaces.";
    case "Multi-Purpose":
      return "Essential service areas, such as restrooms, maintenance rooms, and storage spaces.";
    case "Others (Miscellaneous)":
      return "Uncategorized areas or locations with unique purposes within the campus.";
    default:
      return "No description available.";
  }
}
