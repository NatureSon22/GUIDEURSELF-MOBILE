import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool isEditing = false;
  bool edit = false;
  final TextEditingController _nameController = TextEditingController();

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

    setState(() {
      _isUploading = true;
    });

    try {
      final user = await updateProfile(
          img: _image, accountId: accountId, name: _nameController.text);
      accountProvider.setAccount(account: user);

      // Show success dialog
      _showSuccessDialog('Profile photo updated successfully');
    } catch (e) {
      _showErrorDialog('Failed to update profile');
    } finally {
      setState(() {
        _isUploading = false;
        _image = null;
        edit = false;
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
        actions: [
          TextButton(
            child: Text(
              edit ? "Cancel" : "Edit",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF323232).withOpacity(0.5),
              ),
            ),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                edit = !edit;
                _image = null;
              });
              _nameController.clear();
            },
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
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
                      child: GestureDetector(
                        onTap: () {
                          _image != null
                              ? setState(() {
                                  _image = null;
                                })
                              : _pickImage();
                        },
                        child: edit
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: const Color(0xFF323232)
                                        .withOpacity(0.1),
                                  ),
                                ),
                                child: Icon(
                                  _image != null
                                      ? Icons.close
                                      : FontAwesomeIcons.pen,
                                  size: 20,
                                  color: const Color(0xFF323232),
                                ),
                              )
                            : Container(),
                      ),
                    )
                  ],
                ),
              ),
              const Gap(20),
              if (!edit)
                Text(
                  account["username"],
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF323232).withOpacity(0.8),
                  ),
                ),
              const Gap(35),
              if (edit) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF323232),
                      ),
                    ),
                    const Gap(25),
                    Flexible(
                      child: TextField(
                        controller: _nameController,
                        style: styleText(
                          context: context,
                          fontSizeOption: 15.0,
                          fontWeight: CustomFontWeight.weight500,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: const Color(0xFF323232).withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: const Color(0xFF323232).withOpacity(0.2),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: const Color(0xFF323232).withOpacity(0.2),
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: const Color(0xFF323232).withOpacity(0.2),
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: const Color(0xFF323232).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveProfile(accountId),
                    child: Text(_isUploading ? "Saving..." : "Save Profile"),
                  ),
                ),
                const Gap(40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
