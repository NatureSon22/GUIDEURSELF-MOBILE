import 'package:flutter/material.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:guideurself/features/chat/showlistening.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/providers/transcribing.dart';
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
    final accountProvider = context.read<AccountProvider>();
    final account = accountProvider.account;
    final isGuest = account.isEmpty;
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
      //If there's no conversation, create a temporary one
      if (conversationId == null) {
        if (conversation.isEmpty) {
          final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
          conversationProvider.setConversation(
              conversation: {'conversation_id': tempId}, isNew: true);
          conversationId = tempId;
        }

        // Create a new conversation in the backend
        final newConversation = isGuest
            ? await createConversationAsGuest(name: question)
            : await createConversation(name: question);

        if (!newConversation.containsKey("conversation_id")) {
          throw Exception(
              "Invalid conversation response: Missing conversation_id");
        }

        // Update the conversation with the real ID
        conversationProvider.setConversation(conversation: newConversation);
        conversationId = newConversation["conversation_id"];
      }

      loadingProvider.setIsGeneratingResponse(true);

      final response =
          await sendMessage(conversationId: conversationId!, content: question);

      widget.handleSendQuestion({
        "_id": response["answer"]["id"],
        "content": response["answer"]["content"],
        "is_machine_generated": true,
      });

      loadingProvider.setIsGeneratingResponse(false);
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

      loadingProvider.setIsGeneratingResponse(false);

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
    try {
      if (_isRecording) return;

      final hasPermission = await _record.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Permission denied!",
                style: styleText(
                  context: context,
                  fontSizeOption: 12.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
    } catch (e) {
      debugPrint("Recording error: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (!_isRecording) return;

      await _record.stop();
      setState(() => _isRecording = false);

      if (_filePath != null && await File(_filePath!).exists()) {
        _transcribeAudio();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Recording stopped. Please try again.",
                style: styleText(
                  context: context,
                  fontSizeOption: 12.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Stop recording error: $e");
    }
  }

  Future<void> _transcribeAudio() async {
    try {
      final transcribingProvider = context.read<Transcribing>();
      if (_filePath == null) return;

      transcribingProvider.setIsTranscribing(true);
      String transcript = await transcribeAudio(_filePath!);
      transcribingProvider.setIsTranscribing(false);

      if (mounted) {
        Navigator.pop(context);
      }

      if (transcript.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Transcription failed! Try again.",
                style: styleText(
                  context: context,
                  fontSizeOption: 12.0,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        return;
      }

      await handleSendQuestion(question: transcript);
    } catch (e) {
      debugPrint("Transcription error: $e");
    }
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
    isDismissible: false,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) =>
        RecordInputModal(handleSendQuestion: handleSendQuestion),
  );
}
