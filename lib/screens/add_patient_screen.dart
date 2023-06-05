import 'package:flutter/material.dart';
import 'package:myPatient/utils/add_patient_form.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Ajouter un patient'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(15.0),
          child: AddPersonForm(),
        ));
  }
}
