import 'package:flutter/material.dart';
import 'package:MyPatient/models/patient.dart';
import 'package:MyPatient/utils/update_patient_form.dart';

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
              child: UpdatePersonForm(
                  index: widget.index, patient: widget.patient),
            )));
  }
}
