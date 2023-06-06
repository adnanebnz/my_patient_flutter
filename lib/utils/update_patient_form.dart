import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/patient.dart';

class UpdatePersonForm extends StatefulWidget {
  const UpdatePersonForm(
      {super.key, required this.index, required this.patient});
  final int index;
  final Patient patient;
  @override
  State<UpdatePersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<UpdatePersonForm> {
  // ignore: prefer_typing_uninitialized_variables
  late final _nameController;
  // ignore: prefer_typing_uninitialized_variables
  late final _ageController;
  // ignore: prefer_typing_uninitialized_variables
  late final _diseaseController;
  final _patientFormKey = GlobalKey<FormState>();

  late final Box box;
  late final Box exerciseBox;

  List<Exercise> selectedExercises = [];

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  _updateInfo() async {
    Patient newPerson = Patient(
      name: _nameController.text,
      age: _ageController.text,
      isActive: false,
      disease: _diseaseController.text,
      exercises: selectedExercises,
    );
    await box.putAt(widget.index, newPerson);
    // ignore: avoid_print
    print('Updated successfully');
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('patients');
    exerciseBox = Hive.box('exercises');
    _nameController = TextEditingController(text: widget.patient.name);
    _ageController = TextEditingController(text: widget.patient.age.toString());

    _diseaseController = TextEditingController(text: widget.patient.disease);
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
          const SizedBox(
            height: 24.0,
          ),
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
                    _updateInfo();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Patient modifié avec succès'),
                      ),
                    );
                  }
                },
                child: const Text('Modifier'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
