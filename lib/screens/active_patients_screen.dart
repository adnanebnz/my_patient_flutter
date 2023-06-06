import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myPatient/models/patient.dart';
import 'package:alarm/alarm.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  late final Box box;
  DateTime now = DateTime.now();
  _deleteInfo(int index) async {
    await box.deleteAt(index);
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('patients');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, box, _) {
              return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final patient = box.getAt(index) as Patient;
                    if (patient.isActive) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(patient.name),
                              subtitle: Text(patient.age.toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch.adaptive(
                                    value: patient.isActive,
                                    onChanged: (value) {
                                      setState(() {
                                        patient.isActive = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Durée: ${patient.duration} min"),
                                IconButton(
                                  onPressed: () async => {
                                    await Alarm.set(
                                            alarmSettings: AlarmSettings(
                                                id: index,
                                                dateTime: DateTime(
                                                    now.year,
                                                    now.month,
                                                    now.day,
                                                    now.hour,
                                                    now.minute +
                                                        int.parse(
                                                            patient.duration)),
                                                assetAudioPath:
                                                    "assets/alarm.mp3",
                                                enableNotificationOnKill: true,
                                                notificationBody:
                                                    "Exercise terminé",
                                                notificationTitle:
                                                    "Exercise terminé pour ${patient.name}",
                                                vibrate: true))
                                        .then((value) => {})
                                  },
                                  icon: const Icon(Icons.alarm),
                                  color: Colors.red[900],
                                ),
                                IconButton(
                                    onPressed: () async =>
                                        {await Alarm.stop(index)},
                                    icon: const Icon(Icons.alarm_off),
                                    color: Colors.red[900])
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  });
            }));
  }
}
