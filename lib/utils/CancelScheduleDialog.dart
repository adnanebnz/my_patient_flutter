// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:MyPatient/models/patient.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class CancelScheduleWidget extends StatefulWidget {
  const CancelScheduleWidget({super.key, required this.patient});
  final Patient patient;

  @override
  State<CancelScheduleWidget> createState() => _CancelScheduleWidgetState();
}

class _CancelScheduleWidgetState extends State<CancelScheduleWidget> {
  List<Exercise>? selectedExercises = [];

  void cancelScheduleExerciseAlarm(String exerciseName) {
    Alarm.stop(exerciseName.hashCode);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning, color: Colors.red),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      title: const Text('Annuler les alarmes'),
      content: Container(
        height: 270,
        child: Column(
          children: [
            Text('Exercices pour ${widget.patient.name}:'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
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
              cancelScheduleExerciseAlarm(exercise.name);
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
