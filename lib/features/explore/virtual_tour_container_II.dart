import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guideurself/features/explore/loading_screen.dart';
import 'package:guideurself/features/explore/virtual_tour_screen_II.dart';

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
    Timer(const Duration(seconds: 6), () {
      setState(() {
        _isLoading = false; // Hide the loading screen after 6 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: _isLoading,
            child: const LoadingScreen(), // Show loading screen
          ),
          Visibility(
            visible: !_isLoading,
            child: const VirtualTourScreenII(), // Show main screen after timer
          ),
        ],
      ),
    );
  }
}
