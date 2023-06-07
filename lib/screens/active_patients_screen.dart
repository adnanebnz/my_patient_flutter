import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:alarm/alarm.dart';
import 'package:MyPatient/models/patient.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  late final Box box;
  String searchText = '';
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    box = Hive.box('patients');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('patients'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final patientsBox = Hive.box('patients');
          final activePatients =
              patientsBox.values.where((patient) => patient.isActive).toList();

          return ListView.builder(
            itemCount: activePatients.length,
            itemBuilder: (context, index) {
              final patient = activePatients[index] as Patient;

              return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(children: [
                          ListTile(
                            onLongPress: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CancelScheduleWidget(patient: patient))
                            },
                            onTap: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) => ScheduleDialog(
                                        patient: patient,
                                      ))
                            },
                            title: Text(
                              "${patient.name} / ${patient.age} ans",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            trailing: Switch.adaptive(
                                activeColor: Colors.green,
                                value: patient.isActive,
                                onChanged: (value) => {
                                      setState(() {
                                        patient.isActive = value;
                                      })
                                    }),
                          )
                        ]),
                      )));
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

//TODO widget here

class ScheduleDialog extends StatefulWidget {
  final Patient patient;

  const ScheduleDialog({super.key, required this.patient});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleDialogState createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  List<Exercise>? selectedExercisesArray = [];

  void scheduleExerciseAlarm(String exerciseName, int durationInMinutes) {
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: durationInMinutes));

    Alarm.set(
      alarmSettings: AlarmSettings(
          id: exerciseName.hashCode,
          dateTime: scheduledTime,
          assetAudioPath: "assets/alarm.mp3",
          enableNotificationOnKill: true,
          notificationTitle: "Rappel d'exercice",
          notificationBody: "Exercice $exerciseName terminée!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      title: const Text('Planifier des alarmes'),
      content: Column(
        children: [
          Text('Exercises for ${widget.patient.name}:'),
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
                        if (selectedExercisesArray!.contains(exercise)) {
                          selectedExercisesArray!.remove(exercise);
                        } else {
                          selectedExercisesArray!.add(exercise!);
                        }
                      });
                    },
                    selected: selectedExercisesArray!.contains(exercise),
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
      actions: [
        TextButton(
          onPressed: () {
            // Schedule alarms here
            for (final exercise in selectedExercisesArray!) {
              scheduleExerciseAlarm(
                  exercise.name, int.parse(exercise.duration));
            }
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

//TODO another widget here
class CancelScheduleWidget extends StatefulWidget {
  const CancelScheduleWidget({super.key, required this.patient});
  final Patient patient;

  @override
  State<CancelScheduleWidget> createState() => _CancelScheduleWidgetState();
}

class _CancelScheduleWidgetState extends State<CancelScheduleWidget> {
  List<Exercise>? selectedExercises = [];
  //fill the list with selected exercises
  _addSelectedExersises() async {
    final exerciseBox = Hive.box('patients');
    var selectedExercises =
        exerciseBox.values.where((exercise) => exercise.isSelected).toList();
    setState(() {
      selectedExercises = selectedExercises.cast<Exercise>();
    });
  }

  _removeSelectedExersises() async {
    final exerciseBox = Hive.box('patients');
    var selectedExercises =
        exerciseBox.values.where((exercise) => exercise.isSelected).toList();
    setState(() {
      selectedExercises = selectedExercises.cast<Exercise>();
    });
  }

  void cancelScheduleExerciseAlarm(String exerciseName) {
    Alarm.stop(exerciseName.hashCode);
  }

  @override
  void initState() {
    super.initState();
    _addSelectedExersises();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      title: const Text('Annuler les alarmes'),
      content: Column(
        children: [
          Text('Exercises for ${widget.patient.name}:'),
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
      actions: [
        TextButton(
          onPressed: () {
            // Cancel alarms here
            for (final exercise in selectedExercises!) {
              cancelScheduleExerciseAlarm(exercise.name);
            }
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
