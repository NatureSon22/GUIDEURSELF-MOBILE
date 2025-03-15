import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/services/storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  int _currentStage = 0; // 0: Background, 1: Logo, 2: GIF, 3: Loader
  final storage = StorageService();

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Background
    if (mounted) setState(() => _currentStage = 1); // Show logo

    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) setState(() => _currentStage = 2); // Show GIF intro

    await Future.delayed(const Duration(milliseconds: 8500));
    if (mounted) setState(() => _currentStage = 3); // Show loader

    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) context.go("/feature-overview"); // Navigate

    storage.saveData(key: "hasVisitedSplash", value: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000), // Smooth fade transition
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
        return _buildGifIntro();
      case 3:
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
      child: Image.asset('lib/assets/images/LOGO-md.png'),
    );
  }

  Widget _buildGifIntro() {
    return Center(
      key: const ValueKey(2),
      child: SizedBox(
          width: double.infinity,
          child: Image.asset('lib/assets/webp/full_intro.gif')),
    );
  }

  Widget _buildLoader() {
    return Center(
      key: const ValueKey(3),
      child: CircularProgressIndicator(
        backgroundColor: const Color(0xFF323232).withOpacity(0.1),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF12A5BC)),
      ),
    );
  }
}
