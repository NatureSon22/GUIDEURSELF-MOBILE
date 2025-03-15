import 'package:flutter/material.dart';
import 'package:guideurself/features/explore/category.dart'; // Ensure this file contains getCategoryIcon() & getCategoryColor()
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarkerDetailsDrawer extends StatefulWidget {
  final String markerPhotoUrl;
  final String category;
  final String markerName;
  final String markerDescription;

  const MarkerDetailsDrawer({
    Key? key,
    required this.markerPhotoUrl,
    required this.category,
    required this.markerName,
    required this.markerDescription,
  }) : super(key: key);

  @override
  _MarkerDetailsDrawerState createState() => _MarkerDetailsDrawerState();
}

class _MarkerDetailsDrawerState extends State<MarkerDetailsDrawer> {
  bool _isExpanded = false;
  final DraggableScrollableController _controller = DraggableScrollableController();

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.animateTo(
      _isExpanded ? 1.0 : 0.7,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Marker Image
                if (widget.markerPhotoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.markerPhotoUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 15),

                // Row for Icon and Marker Name
                Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(153, 240, 240, 240),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          getCategoryIcon(widget.category),
                          color: getCategoryColor(widget.category),
                          size: 15,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Marker Name Container
                    IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(85, 121, 233, 250),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.near_me,
                              color: Color.fromARGB(255, 18, 165, 188),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.markerName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 18, 165, 188),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Expand Button
                    InkWell(
                      onTap: _toggleExpansion,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(153, 240, 240, 240),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: _isExpanded
                                ? const Color.fromARGB(255, 18, 165, 188)
                                : Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _isExpanded
                                ? FontAwesomeIcons.downLeftAndUpRightToCenter
                                : FontAwesomeIcons
                                    .upRightAndDownLeftFromCenter,
                            color: _isExpanded
                                ? const Color.fromARGB(255, 18, 165, 188)
                                : Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Marker Description (Justified Text)
                Text(
                  widget.markerDescription,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 13.5, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
