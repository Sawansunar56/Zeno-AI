import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:frontend/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final recorder = FlutterSoundRecorder();
  final audioPlayer = ap.AudioPlayer();
  bool isRecorderReady = false;
  bool isPlaying = false;
  Duration playDuration = Duration.zero;
  Duration playPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    initRecorder();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == ap.PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        playDuration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        playPosition = newPosition;
      });
    });
  }

  @override
  void dispose() {
    recorder.stopRecorder();
    audioPlayer.dispose();
    super.dispose();
  }

  Future setAudio() async {
    final player = ap.AudioCache(prefix: 'assets/');
    final url = await player.load('song.mp3');
    audioPlayer.setSourceUrl(url.path);
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Micorphone not Allowed';
    }

    await recorder.openRecorder();

    isRecorderReady = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print('Recorder audio: $audioFile');
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  @override
  Widget get _navigationDrawer {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      height: 80.0,
      child: BottomAppBar(
          color: backgroundColor,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: IconButton(
                  icon: Icon(Icons.note_add),
                  onPressed: () {},
                ),
              ),
              IconButton(
                icon: Icon(Icons.portrait),
                onPressed: () {},
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  // return Text("${duration.inSeconds} s");
                  String twoDigits(int n) => n.toString().padLeft(20);
                  final twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return Text('$twoDigitMinutes:$twoDigitSeconds');
                },
              ),
            ),
            Slider(
                min: 0,
                max: playDuration.inSeconds.toDouble(),
                value: playPosition.inSeconds.toDouble(),
                onChanged: (value) async {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(playPosition)),
                Text(formatTime(playDuration)),
              ],
            ),
            CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 50,
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                ))
          ],
        ),
        bottomNavigationBar: _navigationDrawer,
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryBlue,
          child:
              Icon(recorder.isRecording ? Icons.stop : Icons.mic_none_outlined),
          onPressed: () async {
            if (recorder.isRecording) {
              await stop();
            } else {
              await record();
            }
            setState(() {});
          },
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
