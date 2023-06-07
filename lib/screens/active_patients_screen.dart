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
                  child: ListTile(
                    title: Text(patient.name),
                    subtitle: Text(patient.disease),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => ScheduleDialog(patient: patient),
                      );
                    },
                    trailing: Column(
                      children: [
                        const Text("Présent?"),
                        Switch.adaptive(
                            activeColor: Colors.green,
                            value: patient.isActive,
                            onChanged: (value) => {
                                  setState(() {
                                    patient.isActive = value;
                                  })
                                }),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class ScheduleDialog extends StatefulWidget {
  final Patient patient;

  const ScheduleDialog({super.key, required this.patient});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleDialogState createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  List<Exercise>? selectedExercises = [];
  void scheduleExerciseAlarm(String exerciseName, int durationInMinutes) {
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: durationInMinutes));

    Alarm.set(
      alarmSettings: AlarmSettings(
          id: exerciseName.hashCode,
          dateTime: scheduledTime,
          assetAudioPath: "assets/alarm.mp3",
          enableNotificationOnKill: true,
          notificationTitle: "Exercise Reminder",
          notificationBody: "It's time for $exerciseName!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: const Text('Schedule Alarms'),
      content: Column(
        children: [
          Text('Exercises for ${widget.patient.name}:'),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.patient.exercises?.length ?? 0,
              itemBuilder: (context, index) {
                final exercise = widget.patient.exercises?[index];
                return ListTile(
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
            for (final exercise in selectedExercises!) {
              scheduleExerciseAlarm(
                  exercise.name, int.parse(exercise.duration));
            }
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Schedule'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
