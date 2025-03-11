import 'package:flutter/material.dart';
import 'package:medico/screens/home_screen.dart';
import 'package:medico/widgets/button_widget.dart';
import 'package:medico/widgets/text_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('assets/images/meds.jpg'),
              fit: BoxFit.cover,
              opacity: 0.6),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Image.asset('assets/images/accent1.png'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      20,
                    ),
                    topRight: Radius.circular(
                      20,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: 'TB X Mobile Health Monitoring App',
                      fontSize: 35,
                      fontFamily: 'Bold',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      textColor: Colors.black,
                      label: 'Get Started',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      },
                      radius: 100,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
