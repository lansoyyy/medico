import 'package:flutter/material.dart';

const secondary = Color(0XFFFF7300);

var primary = Colors.blue[900];
var black = const Color(0xff1b1b1b);
var white = const Color(0xffffffff);
var grey = const Color(0xffB3B3B3);
TimeOfDay parseTime(String timeString) {
  List<String> parts = timeString.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}
