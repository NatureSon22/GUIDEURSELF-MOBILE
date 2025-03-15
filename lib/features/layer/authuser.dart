import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/services/auth.dart';

class AuthLayer extends StatefulWidget {
  const AuthLayer({super.key});

  @override
  State<AuthLayer> createState() => _AuthLayerState();
}

class _AuthLayerState extends State<AuthLayer> {
  late Future<Map<String, dynamic>> _authFuture;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _authFuture = validateUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _authFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF12A5BC),
                backgroundColor: const Color(0xFF323232).withOpacity(0.1),
              ),
            ),
          );
        }

        // Handle navigation once
        if (!_hasNavigated && context.mounted) {
          _hasNavigated = true;

          final isValid = snapshot.data?['valid'] == true;
          final destination = isValid ? '/' : '/login';

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(destination);
          });
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF12A5BC),
              backgroundColor: const Color(0xFF323232).withOpacity(0.1),
            ),
          ),
        );
      },
    );
  }
}
