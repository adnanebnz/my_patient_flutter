import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/patient.dart';

class UpdateExerciceForm extends StatefulWidget {
  const UpdateExerciceForm(
      {super.key, required this.index, required this.exercise});
  final int index;
  final Exercise exercise;

  @override
  State<UpdateExerciceForm> createState() => _UpdateExerciceFormState();
}

class _UpdateExerciceFormState extends State<UpdateExerciceForm> {
  // ignore: prefer_typing_uninitialized_variables
  late final _nameController;
  // ignore: prefer_typing_uninitialized_variables
  late final _durationController;
  final _exerciceFormKey = GlobalKey<FormState>();
  late final Box exerciceBox;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  _updateExo() async {
    Exercise newExercice = Exercise(
      name: _nameController.text,
      duration: _durationController.text,
    );
    exerciceBox.putAt(widget.index, newExercice);
    // ignore: avoid_print
    print('Updated successfully');
  }

  @override
  void initState() {
    super.initState();
    exerciceBox = Hive.box('exercises');
    _nameController = TextEditingController(text: widget.exercise.name);
    _durationController =
        TextEditingController(text: widget.exercise.duration.toString());
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
          const SizedBox(
            height: 24.0,
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
                    _updateExo();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        showCloseIcon: true,
                        behavior: SnackBarBehavior.floating,
                        closeIconColor: Colors.white,
                        content: Text('Exercice modifié avec succès'),
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
