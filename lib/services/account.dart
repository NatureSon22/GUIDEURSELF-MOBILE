import 'dart:io';
import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

Future<Map<String, dynamic>> updateProfile(File img, String accountId) async {
  // Validate file existence
  if (!img.existsSync() || img.lengthSync() == 0) {
    throw Exception('File does not exist or is empty: ${img.path}');
  }

  // Get file extension and validate
  final fileExtension = path.extension(img.path).toLowerCase();
  const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];

  if (!allowedExtensions.contains(fileExtension)) {
    throw Exception(
        'Invalid file type. Only JPG, JPEG, PNG, GIF, and WEBP are allowed.');
  }

  // Get MIME type and validate
  String? mimeType = lookupMimeType(img.path);

  // If MIME type couldn't be determined, set based on extension
  if (mimeType == null) {
    switch (fileExtension) {
      case '.jpg':
      case '.jpeg':
        mimeType = 'image/jpeg';
        break;
      case '.png':
        mimeType = 'image/png';
        break;
      case '.gif':
        mimeType = 'image/gif';
        break;
      case '.webp':
        mimeType = 'image/webp';
        break;
      default:
        mimeType = 'image/jpeg'; // Default fallback
    }
  }

  const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp'
  ];
  if (!allowedMimeTypes.contains(mimeType)) {
    throw Exception('Invalid MIME type. Detected: $mimeType');
  }

  try {
    // Create bytes from file to ensure it's a valid image
    final bytes = await img.readAsBytes();

    // Prepare FormData with explicit MIME type and content type
    final formData = FormData.fromMap({
      "profile_photo": MultipartFile.fromBytes(
        bytes,
        filename: "profile$fileExtension",
        contentType: MediaType.parse(mimeType),
      ),
      "accountId": accountId,
    });

    final response = await dio.put(
      "/accounts/update-profile",
      data: formData,
    );

    return response.data["user"];
  } on DioException catch (_) {
    throw Exception('Failed to update profile photo');
  }
}

Future<List<Map<String, String>>> getAllCampuses() async {
  try {
    final response = await dio.get("/campuses");

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> campusList = response.data;

      return campusList.map((campus) {
        return {
          "_id": campus["_id"]?.toString() ?? "",
          "campus_name": campus["campus_name"]?.toString() ?? "Unknown Campus",
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch campuses: ${response.statusMessage}');
    }
  } on DioException catch (e) {
    throw Exception('Failed to fetch campuses: ${e.message}');
  }
}

Future<void> resetPasswordAccount(String email, String? campusId) async {
  try {
    final response = await dio.put("/accounts/reset-password",
        data: {"email": email, "campusId": campusId, "device": "mobile"});

    final user = response.data;
    print(user);
  } on DioException catch (_) {
    throw Exception('Failed to reset password.');
  }
}
