// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:MyPatient/models/patient.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer show log;

class CancelScheduleWidget extends StatefulWidget {
  const CancelScheduleWidget({super.key, required this.patient});
  final Patient patient;

  @override
  State<CancelScheduleWidget> createState() => _CancelScheduleWidgetState();
}

class _CancelScheduleWidgetState extends State<CancelScheduleWidget> {
  List<Exercise>? selectedExercises = [];

  void _removeSelectedExercisesToPatient(Exercise exercise) {
    setState(() {
      final exercises = selectedExercises;
      Alarm.stop(exercise.name.hashCode);
      exercise.isProgrammed = false;
      exercise.isDone = false;
      exercise.save();
      developer.log(
          "${exercise.name} ${exercise.description} ${exercise.isDone} ${exercise.isProgrammed} ${exercise.duration}");
      exercises?.remove(exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      icon: const Icon(Icons.warning, color: Colors.red),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      title: const Text('Annuler les alarmes'),
      content: SizedBox(
        height: size.height * 0.4,
        width: size.width * 0.7,
        child: Column(
          children: [
            Text('Exercices pour ${widget.patient.name}:'),
            Expanded(
              child: ListView.builder(
                //shrinkWrap: true,
                itemCount: widget.patient.exercises?.length ?? 0,
                itemBuilder: (context, index) {
                  final exercise = widget.patient.exercises?[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ListTile(
                      title: Text(exercise?.name ?? ''),
                      subtitle:
                          Text('Duration: ${exercise?.duration ?? ''} minutes'),
                      onTap: () {
                        setState(() {
                          if (selectedExercises!.contains(exercise)) {
                            selectedExercises!.remove(exercise);
                          } else {
                            selectedExercises!.add(exercise!);
                          }
                        });
                      },
                      selected: selectedExercises!.contains(exercise),
                      selectedTileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      selectedColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Cancel alarms here
            for (final exercise in selectedExercises!) {
              _removeSelectedExercisesToPatient(exercise);
              //reset
              Navigator.of(context).pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
                closeIconColor: Colors.white,
                content: Text('Alarmes annulées'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('CONFIRMER'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('ANNULER'),
        ),
      ],
    );
  }
}
