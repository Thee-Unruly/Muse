import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:muse/services/gemini_service.dart'; // Import your GeminiService
import 'package:muse/screens/reflection_screen.dart'; // Import your ReflectionScreen

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // For audio recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecordingAudio = false;
  String? _audioPath;

  // For speech-to-text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _currentLocaleId = '';

  // For AI processing indicator
  bool _isProcessingAI = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This initializes the speech-to-text engine.
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (errorNotification) => print('Speech error: $errorNotification'),
    );
    if (_speechEnabled) {
      final systemLocale = await _speechToText.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    if (_speechEnabled) {
      // Request microphone permission specifically for speech to text
      if (await Permission.microphone.request().isGranted) {
        await _speechToText.listen(
          onResult: _onSpeechResult,
          listenFor: const Duration(seconds: 30), // Listen for up to 30 seconds
          localeId: _currentLocaleId,
          cancelOnError: true,
          partialResults: true,
          onSoundLevelChange: (level) => print('Sound level: $level'),
        );
        setState(() {
          _isRecordingAudio = false; // Reset audio recording state if starting STT
          _lastWords = ''; // Clear previous transcription
        });
      } else {
        _showPermissionDeniedDialog();
      }
    }
  }

  /// Manually stop the active speech recognition session
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      // No longer listening for speech
    });

    if (_lastWords.isNotEmpty) {
      setState(() {
        _isProcessingAI = true;
      });
      final geminiService = GeminiService();
      final aiReflection = await geminiService.getGeminiAIText(userTranscript: _lastWords);

      setState(() {
        _isProcessingAI = false;
      });

      // Navigate to ReflectionScreen and pass the original text and AI reflection
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReflectionScreen(
            originalText: _lastWords,
            aiRewrittenText: aiReflection,
          ),
        ),
      );
    }
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns a new result.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  // For audio recording - keeping original functionality as well
  // Note: This method is currently not triggered by the UI. If you want to use
  // it, you'll need to add a separate button or modify the existing one's logic.
  Future<void> _startAudioRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/muse_recording.m4a';

        await _audioRecorder.start(
          const RecordConfig(),
          path: path,
        );

        setState(() {
          _isRecordingAudio = true;
          _audioPath = path;
        });
      } else {
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      print('Error starting audio recording: $e');
    }
  }

  Future<void> _stopAudioRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecordingAudio = false;
        _audioPath = path;
      });
      print('Audio recording stopped. File saved to: $_audioPath');
    } catch (e) {
      print('Error stopping audio recording: $e');
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Microphone Permission Denied"),
          content: const Text(
              "Please grant microphone permission to use the recording feature."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              }
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _speechToText.stop(); // Stop listening if still active
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record your thoughts'),
        backgroundColor: Colors.pink.shade100, // Pastel pink
      ),
      body: Container(
        color: Colors.purple.shade50, // Light lavender background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  // Listening indicator for speech-to-text or recording animation
                  if (_speechToText.isListening || _isProcessingAI)
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (_speechToText.isListening || _isProcessingAI)
                            ? Colors.green.withOpacity(0.3) // Green for STT listening or AI processing
                            : Colors.red.withOpacity(0.3), // Red for audio recording
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      // Toggle speech-to-text listening
                      if (_speechToText.isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _speechToText.isListening || _isProcessingAI
                            ? Colors.green.shade300 // Green when listening or processing
                            : Colors.pink.shade300, // Pink when idle
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        _speechToText.isListening ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                _isProcessingAI
                    ? 'Generating reflection...'
                    : _speechToText.isListening
                        ? 'Listening...'
                        : _speechEnabled
                            ? 'Tap microphone to speak'
                            : 'Speech not available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              if (!_isProcessingAI && _lastWords.isNotEmpty)
                Text(
                  _lastWords,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (_audioPath != null && !_isRecordingAudio && !_isProcessingAI) ...[
                const SizedBox(height: 20),
                Text(
                  'Recorded file: ${_audioPath!.split('/').last}',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
