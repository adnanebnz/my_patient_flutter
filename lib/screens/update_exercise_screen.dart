import 'package:flutter/material.dart';
import 'package:MyPatient/models/patient.dart';
import 'package:MyPatient/utils/update_exercice_form.dart';

class UpdateExercisePage extends StatefulWidget {
  const UpdateExercisePage(
      {super.key, required this.index, required this.exercise});
  final int index;
  final Exercise exercise;

  @override
  State<UpdateExercisePage> createState() => _UpdateExercisePageState();
}

class _UpdateExercisePageState extends State<UpdateExercisePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: UpdateExerciceForm(
                  index: widget.index, exercise: widget.exercise),
            )));
  }
}
