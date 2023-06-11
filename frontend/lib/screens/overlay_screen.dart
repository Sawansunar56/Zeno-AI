import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:speech_to_text/speech_to_text.dart';

// import '../services/speech_api.dart';

class OverlayScreen extends StatefulWidget {
  OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  final _speech = SpeechToText();
  bool isListening = false;
  String text = "";

  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print("onStatus: $val"),
        onError: (val) => print("onError: $val"),
      );

      if (available) {
        setState(() {
          isListening = true;
          _speech.listen(
            onResult: (val) => setState(() {
              text = val.recognizedWords;
            }),
          );
        });
      }
    } else {
      setState(() {
        isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text("Say Something"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, text);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 100,
                child: ListView(
                  reverse: true,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AvatarGlow(
              animate: isListening,
              endRadius: 150,
              glowColor: Colors.blue.shade600,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: EdgeInsets.all(40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70.0))),
                onPressed: () {
                  // print(isListening);
                  // print(text);
                  _listen();
                },
                child: Icon(
                  isListening ? Icons.mic_none : Icons.mic,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
