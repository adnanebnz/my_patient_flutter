import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myPatient/screens/info_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IntroScreen();
  }
}

class _IntroScreen extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = const PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28.0, fontWeight: FontWeight.w400, color: Colors.black),
        bodyTextStyle: TextStyle(fontSize: 19.0, color: Colors.black),
        imagePadding: EdgeInsets.all(20),
        boxDecoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
              0.1,
              0.5,
              0.7,
              0.9
            ],
                colors: [
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
            ])));

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Bienvenu a votre application!",
          body: "Notre application vous aide a gerer vos patients.",
          image: intoImage('assets/images/1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ergonomie",
          body:
              "Notre application est facile a utiliser et vous permet de gerer vos patients facilement.",
          image: intoImage('assets/images/2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Laissez un commentaire",
          body:
              "Vous pouvez laisser un commentaire sur google play pour nous aider a ameliorer notre application.",
          image: intoImage('assets/images/3.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => goHomePage(context),
      onSkip: () => goHomePage(context),
      showSkipButton: true,
      nextFlex: 0,
      skip: const Text(
        'Passer',
        style: TextStyle(color: Colors.green),
      ),
      next: const Icon(Icons.arrow_forward, color: Colors.green),
      done: const Text(
        'Commencer',
        style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.w400),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.green,
        activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }

  void goHomePage(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return const InfoPage();
    }), (Route<dynamic> route) => false);
  }
}

Widget intoImage(String assetName) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Image.asset(
      assetName,
      width: 300,
    ),
  );
}
