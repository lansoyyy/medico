import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Medicine').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            }

            final data = snapshot.requireData;
            final medicines = data.docs;

            // Current DateTime
            DateTime now = DateTime.now();

            // Filter missed medicines
            final missedList = medicines.where((element) {
              String storedTime = element['time']; // "HH:mm" format
              String frequency = element['frequency'];

              // Convert storedTime (HH:mm) into DateTime object for today
              DateTime scheduledTime = DateTime(
                now.year,
                now.month,
                now.day,
                int.parse(storedTime.split(':')[0]), // Extract hour
                int.parse(storedTime.split(':')[1]), // Extract minute
              );

              // Check if it's an everyday medicine OR if it's past its scheduled date
              if (frequency == "Everyday") {
                return scheduledTime.isBefore(now);
              } else {
                // Only check date if it's not "Everyday"
                DateTime scheduledDate = element['dateTime'].toDate();
                return scheduledDate.day == now.day &&
                    scheduledTime.isBefore(now);
              }
            }).toList();

            return missedList.isNotEmpty
                ? ListView.builder(
                    itemCount: missedList.length,
                    itemBuilder: (context, index) {
                      final medicine = missedList[index];
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
                              text:
                                  'Medication Intake for ${medicine['name']} is missed',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            TextWidget(
                              text:
                                  'Scheduled: ${medicine['time']} (${medicine['frequency']})',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No missed medications",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Regular'),
                    ),
                  );
          }),
    );
  }
}
