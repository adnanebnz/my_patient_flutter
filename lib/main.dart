import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MyPatient/models/patient.dart';
import 'package:alarm/alarm.dart';
import 'package:MyPatient/screens/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PatientAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  await Hive.openBox('patients');
  await Hive.openBox('exercises');
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyPatient',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
