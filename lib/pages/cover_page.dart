// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sassila_mobile_ui/pages/home_page.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({Key? key}) : super(key: key);

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  @override
  void initState() {
    super.initState();
    //_navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    // //Size of the device
    // var size = MediaQuery.of(context).size;
    return AnimatedSplashScreen(
      nextScreen: HomePage(),
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: double.infinity,
      splash: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/sassila.png'),
                radius: 125,
              ),
              Padding(padding: EdgeInsets.all(10)),
              Text(
                'Bienvenue dans Sassila',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.all(75)),
              Text(
                '',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
