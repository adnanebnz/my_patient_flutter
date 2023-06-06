import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myPatient/screens/info_screen.dart';
import 'package:myPatient/screens/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Widget> getFirstScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool alreadyShown = prefs.getBool('alreadyShown') ?? false;
    if (alreadyShown) {
      return const InfoPage();
    } else {
      return const IntroScreen();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getFirstScreen(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
