import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/services/account.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:go_router/go_router.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Validate file details
        final file = File(pickedFile.path);

        // Get file extension and check size
        final fileExtension = path.extension(file.path).toLowerCase();
        final fileSize = file.lengthSync();

        // Check file size (optional - max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          _showErrorDialog('File too large. Maximum size is 5MB.');
          return;
        }

        // Check file extension
        final allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
        if (!allowedExtensions.contains(fileExtension)) {
          _showErrorDialog(
              'Invalid file type. Only JPG, JPEG, PNG, GIF, and WEBP are allowed.');
          return;
        }

        setState(() {
          _image = file;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image. Please try again.');
    }
  }

  Future<void> _saveProfile(String accountId) async {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final user = await updateProfile(_image!, accountId);
      accountProvider.setAccount(account: user);

      // Show success dialog
      _showSuccessDialog('Profile photo updated successfully');
    } catch (e) {
      _showErrorDialog('Failed to update profile photo');
    } finally {
      setState(() {
        _isUploading = false;
        _image = null;
      });
    }
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: styleText(
            context: context,
            fontSizeOption: 12.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: styleText(
            context: context,
            fontSizeOption: 12.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF323232),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountProvider>().account;
    final String? photoUrl = account["user_photo_url"] as String?;
    final String accountId = account["_id"];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Edit Profile",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _isUploading ? null : _pickImage,
              child: SizedBox(
                width: 200,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 90,
                        backgroundImage: _image != null
                            ? FileImage(_image!) as ImageProvider
                            : (photoUrl != null && photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : const AssetImage(
                                    "lib/assets/images/avatar_placeholder.png")),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFF323232).withOpacity(0.1),
                          ),
                        ),
                        child: _isUploading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF12A5BC),
                                ),
                              )
                            : const Icon(
                                Icons.camera,
                                color: Color(0xFF323232),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Gap(40),
            if (_image != null && !_isUploading)
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () => _saveProfile(accountId),
                  child: const Text("Save Profile"),
                ),
              )
          ],
        ),
      ),
    );
  }
}
