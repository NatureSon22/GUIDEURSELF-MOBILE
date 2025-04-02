import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/widgets/textgradient.dart';

class NavFeature extends StatelessWidget {
  const NavFeature({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                context.push("/about-II");
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 50, 50, 50)
                          .withOpacity(0.08),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/images/BG-BUTTON.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF12A5BC).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      width: 35,
                      height: 35,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF12A5BC),
                            Color(0xFF0E46A3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.lightbulb,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(10),
                    const GradientText(
                      "Know More About the University",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF12A5BC),
                          Color(0xFF0E46A3),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Gap(20),
          Flexible(
            child: GestureDetector(
              onTap: () {
                // Handle tap event
                context.go("/virtual-tour-II");
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 50, 50, 50)
                          .withOpacity(0.08),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/images/BG-BUTTON.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF12A5BC).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      width: 35,
                      height: 35,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF12A5BC),
                            Color(0xFF0E46A3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.location_pin,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(10),
                    const GradientText(
                      "Explore University Virtual Tour",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF12A5BC),
                          Color(0xFF0E46A3),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
