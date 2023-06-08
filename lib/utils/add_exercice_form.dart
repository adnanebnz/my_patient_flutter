import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/patient.dart';

class AddExerciceForm extends StatefulWidget {
  const AddExerciceForm({super.key});

  @override
  State<AddExerciceForm> createState() => _AddExerciceFormState();
}

class _AddExerciceFormState extends State<AddExerciceForm> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _exerciceFormKey = GlobalKey<FormState>();
  late final Box exerciceBox;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  _addExo() async {
    Exercise newExercice = Exercise(
      name: _nameController.text,
      duration: _durationController.text,
    );
    exerciceBox.add(newExercice);
    // ignore: avoid_print
    print('Added successfully');
  }

  @override
  void initState() {
    super.initState();
    exerciceBox = Hive.box('exercises');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _exerciceFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nom de l\'exercice'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Flexion du coude',
              hintStyle: TextStyle(fontSize: 13.0),
              prefixIcon: Icon(Icons.sports_gymnastics_outlined),
            ),
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text('Durée de l\'exercice'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '5 minutes',
              hintStyle: TextStyle(
                fontSize: 13.0,
              ),
              prefixIcon: Icon(Icons.timer_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _durationController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 24.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_exerciceFormKey.currentState!.validate()) {
                    _addExo();
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
