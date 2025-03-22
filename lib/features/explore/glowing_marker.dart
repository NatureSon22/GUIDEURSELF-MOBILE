import 'package:flutter/material.dart';

class GlowingMarker extends StatefulWidget {
  final bool isHighlighted;
  final VoidCallback onTap;

  const GlowingMarker({
    Key? key,
    required this.isHighlighted,
    required this.onTap,
  }) : super(key: key);

  @override
  _GlowingMarkerState createState() => _GlowingMarkerState();
}

class _GlowingMarkerState extends State<GlowingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 5, end: 15).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _animation.value,
                height: _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.isHighlighted
                          ? Colors.red.withOpacity(0.8)
                          : Colors.blue.withOpacity(0.8),
                      blurRadius: _animation.value,
                      spreadRadius: _animation.value / 2,
                    ),
                  ],
                ),
              );
            },
          ),
          Icon(
            Icons.circle, // Better visibility
            color: widget.isHighlighted
                ? Colors.red
                : const Color.fromARGB(255, 23, 130, 192),
            size: 18,
          ),
        ],
      ),
    );
  }
}
