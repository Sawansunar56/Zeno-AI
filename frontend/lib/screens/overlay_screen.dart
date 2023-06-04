import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

import '../services/speech_api.dart';

class OverlayScreen extends StatefulWidget {
  OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  bool isListening = false;
  String text = "";

  // @override
  // void initState() {
  //   super.initState();
  //   resetState();
  // }

  @override
  void dispose() {
    resetState();
    super.dispose();
  }

  void resetState() {
    setState(() {
      isListening = false;
      text = "";
    });
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
      onResult: (text) => setState(() => this.text = text),
      onListening: (isListening) {
        print(this.isListening);
        setState(() {
          print("ongoing");
          this.isListening = isListening;
        });
        print(this.isListening);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text("Get back"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, text);
          },
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AvatarGlow(
            animate: isListening,
            endRadius: 150,
            glowColor: Colors.red.shade700,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.all(40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0))),
              onPressed: () {
                // print(isListening);
                // print(text);
                toggleRecording();
              },
              child: Icon(
                isListening ? Icons.mic_none : Icons.mic,
                size: 50,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
