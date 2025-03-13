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
        itemCount: 10,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  TextWidget(
                    text: 'Medication Intake for 123 is missed',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
