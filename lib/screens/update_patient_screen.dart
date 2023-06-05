import 'package:flutter/material.dart';
import 'package:learning_hive/models/patient.dart';
import 'package:learning_hive/utils/update_patient_form.dart';

class UpdatePatientPage extends StatefulWidget {
  const UpdatePatientPage(
      {super.key, required this.index, required this.patient});
  final int index;
  final Patient patient;
  @override
  State<UpdatePatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<UpdatePatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Modifier un patient'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: UpdatePersonForm(index: widget.index, patient: widget.patient),
        ));
  }
}
