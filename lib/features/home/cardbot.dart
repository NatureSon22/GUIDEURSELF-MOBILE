import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/services/storage.dart';
import 'package:guideurself/widgets/textgradient.dart';
import 'package:go_router/go_router.dart';

class CardBot extends StatelessWidget {
  const CardBot({
    super.key,
  });
  static final StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: const Color.fromARGB(255, 50, 50, 50).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Stack(
        children: [
          Positioned(
            right: -95,
            bottom: -47,
            child: Transform.rotate(
              angle: -0.1,
              child: ClipRect(
                child: SizedBox(
                  height: 200,
                  width: 230,
                  child: Image.asset(
                    'lib/assets/webp/full_float3.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            padding:
                const EdgeInsets.only(top: 18, left: 18, right: 18, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GradientText(
                  "Meet Giga!",
                  gradient: LinearGradient(
                    colors: [Color(0xFF12A5BC), Color(0xFF0E46A3)],
                  ),
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Meet Giga, your friendly virtual guide, here to assist with campus tours, answer questions, and make your university experience easier.",
                  style: styleText(
                    context: context,
                    fontSizeOption: 10.3,
                  ),
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(right: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      final hasVisited = storage.getData(key: "visited-chat");
                      context.go(hasVisited == true ? "/chatbot" : "/chat");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(fontSize: 13.5),
                    ),
                    child: const Text("Chat Now"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Clipper for the Curved Background
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 50); // Start from bottom left
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    ); // Curve to bottom right
    path.lineTo(size.width, 0); // Top right corner
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
