import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordInputModal extends StatefulWidget {
  const RecordInputModal({super.key});

  @override
  _RecordInputModalState createState() => _RecordInputModalState();
}

class _RecordInputModalState extends State<RecordInputModal> {
  final AudioRecorder _record = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecord() async {
    bool hasPermission = await _record.hasPermission();
    if (hasPermission) {
      final dir = await getApplicationDocumentsDirectory();
      _filePath = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(const RecordConfig(), path: _filePath!);
      setState(() {
        _isRecording = true;
        _isPlaying = false;
      });
      print('Recording started: $_filePath');
    } else {
      print('Permission denied');
    }
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    _record.dispose();
    setState(() {
      _isRecording = false;
    });

    if (_filePath != null && await File(_filePath!).exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording saved: $_filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording failed!')),
      );
    }
  }

  Future<void> _playRecording() async {
    if (_filePath != null && await File(_filePath!).exists()) {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(_filePath!));
        setState(() {
          _isPlaying = true;
        });

        // Listen for playback completion
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            _isPlaying = false;
          });
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording found!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Record button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor:
                      _isRecording ? Colors.red : const Color(0xFF12A5BC),
                  minimumSize: const Size(70, 70),
                ),
                onPressed: () async {
                  if (_isRecording) {
                    await _stopRecording();
                  } else {
                    await _startRecord();
                  }
                },
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              // Play button
              if (_filePath != null && !_isRecording)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color(0xFF12A5BC),
                    minimumSize: const Size(70, 70),
                  ),
                  onPressed: _playRecording,
                  child: Icon(
                    _isPlaying ? Icons.stop : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Call this function to show the modal
Future<void> recordInput(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) => const RecordInputModal(),
  );
}