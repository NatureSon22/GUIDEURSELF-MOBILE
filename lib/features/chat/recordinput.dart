import 'package:flutter/material.dart';
import 'package:guideurself/features/chat/showlistening.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/services/conversation.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordInputModal extends StatefulWidget {
  final Function handleSendQuestion;
  const RecordInputModal({super.key, required this.handleSendQuestion});

  @override
  State<RecordInputModal> createState() => _RecordInputModalState();
}

class _RecordInputModalState extends State<RecordInputModal> {
  final AudioRecorder _record = AudioRecorder();
  bool _isRecording = false;
  String? _filePath;
  final String _transcription = "Press the mic and start speaking...";

  @override
  void dispose() {
    _record.dispose();
    super.dispose();
  }

  Future<void> handleSendQuestion({required String question}) async {
    final conversationProvider =
        Provider.of<ConversationProvider>(context, listen: false);
    final loadingProvider = context.read<LoadingProvider>();
    final conversation = conversationProvider.conversation;
    String? conversationId = conversation['conversation_id'];

    final String tempMessageId =
        DateTime.now().millisecondsSinceEpoch.toString();

    // Immediately show the user's question in the UI
    widget.handleSendQuestion({
      "_id": tempMessageId,
      "content": question,
      "is_machine_generated": false,
    });

    try {
      // If there's no conversation, create a temporary one
      if (conversationId == null) {
        if (conversation.isEmpty) {
          final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
          conversationProvider.setConversation(
              conversation: {'conversation_id': tempId}, isNew: false);
        }

        // Create a new conversation in the backend
        final newConversation = await createConversation(name: question);

        if (!newConversation.containsKey("conversation_id")) {
          throw Exception(
              "Invalid conversation response: Missing conversation_id");
        }

        // Update the conversation with the real ID
        conversationProvider.setConversation(
            conversation: newConversation, isNew: true);
        conversationId = newConversation["conversation_id"];
      }

      loadingProvider.setIsGeneratingResponse(true);

      // Send the message to the backend
      final response =
          await sendMessage(conversationId: conversationId!, content: question);

      loadingProvider.setIsGeneratingResponse(false);

      widget.handleSendQuestion({
        "_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "content": response["answer"]["content"],
        "is_machine_generated": true,
      });
    } catch (e) {
      // More detailed error handling
      final String errorMessage;
      if (e.toString().contains("network")) {
        errorMessage = "Network error. Please check your connection.";
      } else if (e.toString().contains("500")) {
        errorMessage = "Server error. Please try again later.";
      } else {
        errorMessage = "Failed to send message. Please try again.";
      }

      // Show error message in the UI
      widget.handleSendQuestion({
        "_id": conversationId ?? tempMessageId,
        "content": errorMessage,
        "is_machine_generated": true,
        "is_failed": true,
      });

      debugPrint("Message error: $e");
    }
  }

  Future<void> _startRecording() async {
    final hasPermission = await _record.hasPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
    setState(() => _filePath = filePath);

    await _record.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: filePath,
    );

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    setState(() => _isRecording = false);

    if (_filePath != null && await File(_filePath!).exists()) {
      _transcribeAudio();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording failed!')),
        );
      }
    }
  }

  Future<void> _transcribeAudio() async {
    if (_filePath == null) return;

    String transcript = await transcribeAudio(_filePath!);

    if (mounted) {
      Navigator.pop(context);
    }

    await handleSendQuestion(question: transcript);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Showlistening(),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: _isRecording
                  ? const Color.fromRGBO(239, 68, 68, 1)
                  : const Color(0xFF12A5BC),
            ),
            onPressed: _isRecording ? _stopRecording : _startRecording,
            child: Icon(
              _isRecording ? Icons.stop : Icons.mic_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> recordInput(BuildContext context, Function handleSendQuestion) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // isDismissible: isLoading,
    // enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) =>
        RecordInputModal(handleSendQuestion: handleSendQuestion),
  );
}
