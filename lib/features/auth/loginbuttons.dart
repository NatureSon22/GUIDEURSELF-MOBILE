import 'package:flutter/material.dart';

class LoginButtons extends StatefulWidget {
  final VoidCallback handleLogin;
  const LoginButtons({super.key, required this.handleLogin});

  @override
  State<LoginButtons> createState() => _LoginButtonsState();
}

class _LoginButtonsState extends State<LoginButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            widget.handleLogin();
          },
          style: Theme.of(context).elevatedButtonTheme.style,
          child: const Text(
            "Login",
          ),
        ),
        const SizedBox(height: 5),
        OutlinedButton(
          onPressed: () {},
          style: Theme.of(context).outlinedButtonTheme.style,
          child: const Text(
            "Continue as Guest",
          ),
        )
      ],
    );
  }
}
