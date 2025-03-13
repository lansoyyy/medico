import 'package:flutter/material.dart';
import 'package:medico/widgets/text_widget.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: TextWidget(
          text: 'Notifications',
          fontSize: 18,
          color: Colors.black,
        ),
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: 1,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.red,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: 'Medication Intake for Azithromycin is missed',
                  fontSize: 16,
                  color: Colors.black,
                ),
                TextWidget(
                  text: 'Scheduled: 10:10PM (Everyday)',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
