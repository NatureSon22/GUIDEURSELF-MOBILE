import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/services/auth.dart';
import 'package:provider/provider.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showNewPassword = false;
  bool showConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();

    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    final account = accountProvider.account;

    if (mounted) {
      Future.microtask(() {
        oldPasswordController.text = account['password'] ?? '';
      });
    }
  }

  Future<void> handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final accountProvider =
          Provider.of<AccountProvider>(context, listen: false);
      final account = accountProvider.account;

      final updatedAccount = await updatePassword(
          password: newPasswordController.text, accountId: account['_id']);

      accountProvider.setAccount(account: updatedAccount);

      // oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Change Password",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Old Password",
                    style: styleText(context: context, fontSizeOption: 12.0),
                  ),
                  const Gap(5),
                  TextFormField(
                    controller: oldPasswordController,
                    cursorColor: const Color(0xFF323232),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Enter old password",
                    ),
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your old password'
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Password",
                    style: styleText(context: context, fontSizeOption: 12.0),
                  ),
                  const Gap(5),
                  TextFormField(
                    controller: newPasswordController,
                    cursorColor: const Color(0xFF323232),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Enter new password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          size: 20,
                          showNewPassword
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !showNewPassword,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a new password'
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm Password",
                    style: styleText(context: context, fontSizeOption: 12.0),
                  ),
                  const Gap(5),
                  TextFormField(
                    controller: confirmPasswordController,
                    cursorColor: const Color(0xFF323232),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Confirm new password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          size: 20,
                          showConfirmPassword
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !showConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    handleUpdatePassword();
                  },
                  child: const Text('Update Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
