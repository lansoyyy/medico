import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:medico/screens/home_screen.dart';
import 'package:medico/widgets/button_widget.dart';
import 'package:medico/widgets/text_widget.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.blue,
              size: 300,
            ),
            TextWidget(
              text: 'Medicine Intake Reminder!',
              fontSize: 18,
              fontFamily: 'Bold',
              color: Colors.black,
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: widget.medicines.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.medication, color: Colors.blue),
                      title: TextWidget(
                        align: TextAlign.start,
                        text: widget.medicines[index]['name'],
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Bold',
                      ),
                      trailing: TextWidget(
                        align: TextAlign.start,
                        text: widget.medicines[index]['dose'],
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Regular',
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
              textColor: Colors.white,
              label: 'Done',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              radius: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
