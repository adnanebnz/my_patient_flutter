import 'package:flutter/material.dart';
import 'package:myPatient/utils/add_exercice_form.dart';

class AddExercicePage extends StatefulWidget {
  const AddExercicePage({super.key});

  @override
  State<AddExercicePage> createState() => _AddExercicePageState();
}

class _AddExercicePageState extends State<AddExercicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Ajouter un exercice'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(15.0),
          child: AddExerciceForm(),
        ));
  }
}
