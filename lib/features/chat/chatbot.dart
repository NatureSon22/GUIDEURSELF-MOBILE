import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/chat/messagedrawer.dart';
import 'package:guideurself/features/chat/messageinput.dart';
import 'package:guideurself/features/chat/questions.dart';
import 'package:guideurself/widgets/textgradient.dart';
import 'package:gap/gap.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  String? question;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add this key

  void handleSelectQuestion(String selectedQuestion) {
    setState(() {
      question = selectedQuestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign key to Scaffold
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go("/chat");
            FocusScope.of(context).unfocus();
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Corrected here
            },
            icon: const Icon(
              Icons.menu,
              size: 27,
            ),
          ),
        ],
        title: Text("Giga", style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      endDrawer: const MessageDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const GradientText(
                    "Hey there, I'm Giga!",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    gradient: LinearGradient(colors: [
                      Color(0xFF12A5BC),
                      Color(0xFF0E46A3),
                    ]),
                  ),
                  const Gap(4),
                  SizedBox(
                    width: 280,
                    child: Text(
                      "Got questions? Ask away, and I’ll do my best to help you out!",
                      textAlign: TextAlign.center,
                      style: styleText(
                        context: context,
                        fontSizeOption: FontSizeOption.size200,
                        lineHeightOption: LineHeightOption.height200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (question == null)
              Questions(handleSelectQuestion: handleSelectQuestion)
            else
              const SizedBox.shrink(),
            MessageInput(
              question: question,
            ),
          ],
        ),
      ),
    );
  }
}
