import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../models/patient.dart';

class AddPersonForm extends StatefulWidget {
  const AddPersonForm({super.key});

  @override
  State<AddPersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _patientFormKey = GlobalKey<FormState>();
  bool addExercise = false;
  late final Box box;
  late final Box exerciseBox;
  List<Exercise> selectedExercises = [];

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  _addInfo() async {
    Patient newPerson = Patient(
      name: _nameController.text,
      age: _ageController.text,
      isActive: false,
      disease: _diseaseController.text,
      exercises: selectedExercises,
    );

    await box.add(newPerson);
    // ignore: avoid_print
    print('Added successfully');
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('patients');
    exerciseBox = Hive.box('exercises');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _patientFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nom et prénom'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text('Age'),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _ageController,
            validator: _fieldValidator,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text('Maladie'),
          TextFormField(
            controller: _diseaseController,
            validator: _fieldValidator,
          ),
          // fetch exercises from hive and display them as options
          const SizedBox(
            height: 24.0,
          ),
          const Text('Exercices'),
          Expanded(
            child: ListView.builder(
              itemCount: exerciseBox.length,
              itemBuilder: (context, index) {
                Exercise exercise = exerciseBox.getAt(index);
                return CheckboxListTile(
                  title: Text(exercise.name),
                  value: selectedExercises.contains(exercise),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedExercises.add(exercise);
                      } else {
                        selectedExercises.remove(exercise);
                      }
                    });
                  },
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 24.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_patientFormKey.currentState!.validate()) {
                    _addInfo();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Sauvgarder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
