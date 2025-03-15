import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginButtons extends StatefulWidget {
  final VoidCallback handleLogin;
  final bool isLoading;
  const LoginButtons(
      {super.key, required this.handleLogin, required this.isLoading});

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
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Text(
            widget.isLoading ? "Logging in" : "Login",
          ),
        ),
        const SizedBox(height: 5),
        OutlinedButton(
          onPressed: () {
            context.go("/");
          },
          style: Theme.of(context).outlinedButtonTheme.style,
          child: const Text(
            "Continue as Guest",
          ),
        )
      ],
    );
  }
}
