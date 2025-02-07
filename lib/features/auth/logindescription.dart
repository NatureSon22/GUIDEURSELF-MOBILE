import 'package:flutter/material.dart';

class LoginDescription extends StatelessWidget {
  const LoginDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 5),
        Text(
            'Log in to explore campus tours, get quick answers from Giga, and access all the resources you need to navigate university.',
           
            style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
