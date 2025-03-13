import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  List medicines;

  ReminderScreen({super.key, required this.medicines});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playAudio();
  }

  late AudioPlayer player = AudioPlayer();
  playAudio() async {
    player.setReleaseMode(ReleaseMode.loop);
    player.setVolume(1);

    await player.setSource(
      AssetSource(
        'mixkit-morning-clock-alarm-1003.wav',
      ),
    );

    await player.resume();
  }

  pauseAudio() async {
    await player.stop();
  }

  @override
  void dispose() {
    super.dispose();
    pauseAudio();

    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
