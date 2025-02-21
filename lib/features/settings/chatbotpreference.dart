import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';

class ChatbotPreference extends StatelessWidget {
  const ChatbotPreference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Chatbot Preferences",
          style: styleText(
              context: context,
              fontSizeOption: 17.0,
              fontWeight: CustomFontWeight.weight500),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
              overlayColor: const Color.fromRGBO(239, 68, 68, 1),
              backgroundColor: const Color.fromRGBO(239, 68, 68, 0.1),
              side: const BorderSide(
                color: Color.fromRGBO(239, 68, 68, 1),
                width: 1,
              )),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Color.fromRGBO(239, 68, 68, 1), size: 20),
              SizedBox(width: 10),
              Text(
                "Clear Chat History",
                style: TextStyle(
                  color: Color.fromRGBO(239, 68, 68, 1),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
