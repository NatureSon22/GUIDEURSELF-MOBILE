import 'package:flutter/material.dart';
import 'package:guideurself/features/auth/loginbuttons.dart';
import 'package:guideurself/features/auth/logindescription.dart';
import 'package:guideurself/features/auth/loginfields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void toggleRememberMe() {
    setState(() {
      _rememberMe = !_rememberMe;
    });
  }

  void handleLogin() {
    if (_formKey.currentState!.validate()) {
      debugPrint(_emailController.text);
      debugPrint(_passwordController.text);
      debugPrint(_rememberMe.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('lib/assets/images/LOGO-md.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const LoginDescription(),
                        const SizedBox(height: 40),
                        LoginFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          handleRememberMe: toggleRememberMe,
                        ),
                        const SizedBox(height: 40),
                        LoginButtons(
                          handleLogin: handleLogin,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Terms of Service",
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Privacy Policy"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
