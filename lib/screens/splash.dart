import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  int _currentStage = 0; // 0: Background, 1: Logo, 2: Loader

  @override
  void initState() {
    super.initState();

    // Start stage 1: Background fade in
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() => _currentStage = 1);

      // Stage 2: Fade out background & fade in logo
      Future.delayed(const Duration(milliseconds: 2200), () {
        setState(() => _currentStage = 2);

        // Stage 3: Fade out logo & show loader
        Future.delayed(const Duration(milliseconds: 2500), () {
          setState(() => _currentStage = 3);

          // Navigate after last animation
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (mounted) context.go("/feature-overview");
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1200), // Smooth transitions
        child: _buildStage(),
      ),
    );
  }

  Widget _buildStage() {
    switch (_currentStage) {
      case 0:
        return _buildBackground();
      case 1:
        return _buildLogo();
      case 2:
        return _buildLoader();
      default:
        return Container(); // Empty after animation
    }
  }

  Widget _buildBackground() {
    return Container(
      key: const ValueKey(0),
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF12A5BC),
    );
  }

  Widget _buildLogo() {
    return Center(
      key: const ValueKey(1),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 1500),
        child: Image.asset('lib/assets/images/LOGO-md.png'),
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      key: ValueKey(2),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 1500),
        child: LoadingIndicator(),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF12A5BC)),
    );
  }
}
