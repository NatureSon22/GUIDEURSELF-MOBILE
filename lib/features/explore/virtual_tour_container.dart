import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guideurself/features/explore/loading_screen.dart';
import 'package:guideurself/features/explore/virtual_tour_screen.dart';

class VirtualTourContainer extends StatefulWidget {
  const VirtualTourContainer({super.key});

  @override
  State<VirtualTourContainer> createState() => _VirtualTourContainerState();
}

class _VirtualTourContainerState extends State<VirtualTourContainer> {
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
            child: const VirtualTourScreen(), // Show main screen after timer
          ),
        ],
      ),
    );
  }
}
