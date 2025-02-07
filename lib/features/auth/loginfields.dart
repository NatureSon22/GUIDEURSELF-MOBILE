import 'package:flutter/material.dart';

class LoginFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback handleRememberMe;

  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.handleRememberMe,
  });

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  bool showPassword = false;
  bool rememberMe = false; // Added variable for checkbox state

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          cursorColor: const Color(0xFF323232),
          style: const TextStyle(fontSize: 14),
          controller: widget.emailController,
          decoration: const InputDecoration(
            hintText: "Enter email",
            labelText: "Email",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            TextFormField(
              cursorColor: const Color(0xFF323232),
              style: const TextStyle(fontSize: 14),
              controller: widget.passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                hintText: "Enter password",
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    size: 20,
                    showPassword
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 24,
                      child: Checkbox(
                        value: rememberMe,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                          widget.handleRememberMe();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember Me',
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Forgot password action
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
