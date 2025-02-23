import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/services/auth.dart';

class AuthLayer extends StatelessWidget {
  const AuthLayer({super.key});

  Future<Map<String, dynamic>> _validateUser() async {
    return await validateUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _validateUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF12A5BC),
              ),
            ),
          );
        }

        Future.microtask(() {
          if (!snapshot.hasData || snapshot.hasError) {
            if (context.mounted) {
              context.go('/login');
            }
          } else {
            final isValid = snapshot.data?['valid'] == true;
            if (context.mounted) {
              context.go(isValid ? '/' : '/login');
            }
          }
        });

        // Empty placeholder to avoid build errors
        return const Scaffold(body: SizedBox());
      },
    );
  }
}
