import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'Splash',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900),
      )),
    );
  }
}
