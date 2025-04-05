import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guideurself/features/explore/loading_screen.dart';
import 'package:guideurself/features/explore/virtual_tour_screen.dart';

class SessionTracker {
  static bool hasShownLoadingThisSession = false;
}

class VirtualTourContainerII extends StatefulWidget {
  const VirtualTourContainerII({super.key});

  @override
  State<VirtualTourContainerII> createState() => _VirtualTourContainerIIState();
}

class _VirtualTourContainerIIState extends State<VirtualTourContainerII> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    if (SessionTracker.hasShownLoadingThisSession) {
      // Skip if already shown in this session
      setState(() => _isLoading = false);
    } else {
      // First time in this session
      SessionTracker.hasShownLoadingThisSession = true;
      Timer(const Duration(seconds: 6), () {
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading) const LoadingScreen(),
          if (!_isLoading) const VirtualTourScreen(),
        ],
      ),
    );
  }
}