import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medico/firebase_options.dart';
import 'package:medico/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'tbx-mobile-health-monitoring',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TB X Mobile Health Monitoring App',
      home: const WelcomeScreen(),
    );
  }
}
