import 'package:flutter/material.dart';

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
    case "Others (Miscellaneous)":
      return Icons.widgets; // Square plus icon
    default:
      return Icons.help_outline; // Default unknown icon
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case "Academic Spaces":
      return Colors.blue;
    case "Administrative Offices":
      return Colors.red;
    case "Student Services":
      return Colors.orange;
    case "Campus Attraction":
      return Colors.green;
    case "Utility Areas":
      return Colors.purple;
    case "Others (Miscellaneous)":
      return Colors.grey;
    default:
      return Colors.black;
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
    case "Others (Miscellaneous)":
      return "Uncategorized areas or locations with unique purposes within the campus.";
    default:
      return "No description available.";
  }
}
