// ignore: file_names
import 'package:MyPatient/models/patient.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer show log;

class ScheduleDialog extends StatefulWidget {
  final Patient patient;

  const ScheduleDialog({super.key, required this.patient});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleDialogState createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  List<Exercise>? selectedExercisesArray = [];
  // ignore: unused_field
  final _durationController = TextEditingController();
  void _addSelectedExercisesToPatient(Exercise exercise) {
    setState(() {
      final isExerciseSelected = selectedExercisesArray!.contains(exercise);
      if (isExerciseSelected) {
        exercise.isProgrammed = true;
      } else {
        exercise.isProgrammed = false;
      }

      widget.patient.selectedExercises?.add(exercise);
      widget.patient.save();
    });
  }

  void scheduleExerciseAlarm(String exerciseName, int durationInMinutes) {
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: durationInMinutes));

    Alarm.set(
      alarmSettings: AlarmSettings(
          id: exerciseName.hashCode,
          dateTime: scheduledTime,
          assetAudioPath: "assets/alarm.mp3",
          enableNotificationOnKill: true,
          notificationTitle: "Rappel d'exercice pour ${widget.patient.name}",
          notificationBody: "Exercice $exerciseName terminée!"),
    );
  }

  Future<String?> editPatientExerciseDurationDialog(
      Patient patient, Exercise exercise) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        // ignore: no_leading_underscores_for_local_identifiers
        final _durationController = TextEditingController();

        return AlertDialog(
          title: const Text('Modifier la durée'),
          content: TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Durée en minutes',
                prefixIcon: Icon(Icons.timer_outlined)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final duration = _durationController.text;
                Navigator.of(context).pop(duration);
              },
              child: const Text('Enregistrer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      icon: const Icon(
        Icons.alarm,
        color: Colors.green,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      title: const Text('Planifier des alarmes'),
      content: SizedBox(
        height: size.height * 0.4,
        width: size.width * 0.7,
        child: Column(
          children: [
            Text('Exercices pour ${widget.patient.name}:'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.patient.exercises?.length ?? 0,
                itemBuilder: (context, index) {
                  final exercise = widget.patient.exercises?[index];
                  final isExerciseSelected =
                      selectedExercisesArray!.contains(exercise);
                  final isExerciseProgrammed = exercise?.isProgrammed ?? false;
                  final isExerciseCompleted = exercise?.isDone ?? false;

                  return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ListTile(
                        title: Text(
                          exercise?.name ?? '',
                          style: TextStyle(
                            color: isExerciseProgrammed
                                ? Colors.green
                                : Colors.black,
                            decoration: isExerciseCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          isExerciseProgrammed
                              ? 'Duration: ${exercise?.duration ?? ''} minutes'
                              : 'Non Programmée',
                        ),
                        onTap: () async {
                          final enteredDuration =
                              await editPatientExerciseDurationDialog(
                            widget.patient,
                            exercise!,
                          );

                          if (enteredDuration != null) {
                            setState(() {
                              exercise.duration = enteredDuration;
                            });
                            setState(() {
                              if (isExerciseSelected) {
                                selectedExercisesArray!.remove(exercise);
                              } else {
                                selectedExercisesArray!.add(exercise);
                              }
                            });
                          }
                        },
                        selected: isExerciseSelected,
                        selectedTileColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        selectedColor: Colors.green,
                        trailing: isExerciseProgrammed
                            ? const Icon(
                                Icons.alarm_on,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.alarm_add,
                                color: Colors.blue,
                              ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Schedule alarms here
            for (final exercise in selectedExercisesArray!) {
              // add selected exercises to patient
              _addSelectedExercisesToPatient(exercise);

              // schedule alarm
              scheduleExerciseAlarm(
                exercise.name,
                int.parse(exercise.duration),
              );

              // update isProgrammed property
              exercise.isProgrammed = true;
              exercise.isDone = false;
              exercise.save();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
                closeIconColor: Colors.white,
                content: Text('Alarmes planifiées avec succès'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('PLANIFIER'),
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
