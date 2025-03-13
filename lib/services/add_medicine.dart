import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future addMedicine(String name, String dose, String frequency, TimeOfDay time,
    DateTime date) async {
  final docUser = FirebaseFirestore.instance.collection('Medicine').doc();

  final json = {
    'name': name,
    'dose': dose,
    'frequency': frequency,
    'time':
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}', // Convert TimeOfDay to a 24-hour format string

    'dateTime':
        frequency == 'Week' || frequency == 'Month' ? date : DateTime.now(),
    'id': docUser.id,
  };

  await docUser.set(json);
}
