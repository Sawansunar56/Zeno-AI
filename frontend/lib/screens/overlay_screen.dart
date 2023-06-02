import 'package:flutter/material.dart';

import '../services/speech_api.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  bool isListening = false;
  String text = "Press the button and start speaking";
  Future toggleRecording() => SpeechApi.toggleRecording(
      onResult: (text) => setState(() => this.text = text),
      onListening: (isListening) {
        setState(() => this.isListening = isListening);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get back"),
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              toggleRecording();
            },
            child: Text(isListening ? "Record" : "Pause")),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, text);
            },
            child: Text("get Back"))
      ]),
    );
  }
}
