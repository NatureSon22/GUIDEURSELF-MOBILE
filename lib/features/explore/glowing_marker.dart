import 'package:flutter/material.dart';
import 'package:guideurself/features/explore/category.dart';

class GlowingMarker extends StatefulWidget {
  final bool isHighlighted;
  final VoidCallback onTap;
  final String category;

  const GlowingMarker({
    Key? key,
    required this.isHighlighted,
    required this.onTap,
    required this.category,
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
      duration: const Duration(milliseconds: 750),
    );

    _animation = Tween<double>(begin: 27, end: 40).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Smooth one-way expansion
    ));

    _startPulse();
  }

  void _startPulse() {
    _controller.forward().then((_) {
      _controller.reset(); // Reset instead of reversing
      _startPulse(); // Loop infinitely
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color categoryColor = getCategoryColor(widget.category);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // One-way expanding pulse effect
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _animation.value,
                height: _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: categoryColor.withOpacity(0.4),
                ),
              );
            },
          ),
          // Background for the icon
          Container(
            width: 26, // Fixed size background
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: categoryColor, // Solid color background
            ),
            child: Center(
              child: Icon(
                getCategoryIcon(widget.category),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
