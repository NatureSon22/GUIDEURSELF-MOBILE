import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guideurself/core/constants/frequentlyasked.dart';

class Questions extends StatefulWidget {
  final Function handleSelectQuestion;

  const Questions({super.key, required this.handleSelectQuestion});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoScroll();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_controller.hasClients) {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.offset;

        if (currentScroll >= maxScroll) {
          _controller.jumpTo(0); // Instantly reset to the start
        } else {
          _controller
              .jumpTo(currentScroll + 1); // Move slightly without animation
        }
      }
    });
  }

  void stopScrolling() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final label =
              frequentlyAsked[index % frequentlyAsked.length]['label'] ?? '';
          final String question =
              frequentlyAsked[index % frequentlyAsked.length]['question'] ?? '';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: OutlinedButton(
              onPressed: () {
                widget.handleSelectQuestion(question);
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
