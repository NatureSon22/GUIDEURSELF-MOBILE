import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class MessageInput extends StatefulWidget {
  final String? question;
  const MessageInput({super.key, required this.question});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _controller.text = widget.question!;
    }
  }

  @override
  void didUpdateWidget(covariant MessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question && widget.question != null) {
      _controller.text = widget.question!;
      SystemChannels.textInput.invokeMethod("TextInput.show");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 13),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF323232).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: BorderSide(
                color: const Color(0xFF323232).withOpacity(0.1),
                width: 1,
              ),
              padding: const EdgeInsets.all(8),
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.mic_none_sharp,
              size: 20,
            ),
          ),
          const Gap(4),
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 12),
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type something here...",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF323232).withOpacity(0.3),
                    width: 0.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF323232).withOpacity(0.8),
                    width: 0.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          const Gap(4),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                _controller.clear(); // Clear the text field after sending
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(11),
            ),
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: const Icon(
                Icons.send,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
