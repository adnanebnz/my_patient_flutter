// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myPatient/models/patient.dart';
import 'package:myPatient/screens/active_patients_screen.dart';
import 'package:myPatient/screens/add_patient_screen.dart';
import 'package:myPatient/screens/update_patient_screen.dart';
import 'package:alarm/alarm.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late final Box box;
  bool value = false;
  DateTime now = DateTime.now();

  _setIsActive(int index, bool isActive) async {
    Patient patient = box.getAt(index);
    patient.isActive = isActive;
    await box.putAt(index, patient);
  }

  _deleteInfo(int index) async {
    await box.deleteAt(index);
    print('Deleted successfully');
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('patients');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Mes Patients'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.list),
                  text: 'Mes patients',
                ),
                Tab(
                  icon: Icon(Icons.checklist_rtl),
                  text: 'Patients active',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: ValueListenableBuilder(
                        valueListenable: box.listenable(),
                        builder: (context, box, widget) {
                          if (box.isEmpty) {
                            return const Center(
                              child: Text('Aucun patient'),
                            );
                          } else {
                            return ListView.builder(
                                itemCount: box.length,
                                itemBuilder: (context, index) {
                                  var patient = box.getAt(index) as Patient;
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        surfaceTintColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 4,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  "${patient.name} / ${patient.age} ans",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text(
                                                  "Excercice: ${patient.exercise}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Switch.adaptive(
                                                      value: patient.isActive,
                                                      onChanged: (value) => {
                                                            _setIsActive(
                                                                index, value)
                                                          }),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    UpdatePatientPage(
                                                                        index:
                                                                            index,
                                                                        patient:
                                                                            patient)));
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      color: Colors.blue[600]),
                                                  IconButton(
                                                    onPressed: () {
                                                      _deleteInfo(index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    color: Colors.red[900],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "Durée: ${patient.duration} min"),
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
                                                                        int.parse(patient
                                                                            .duration)),
                                                                assetAudioPath:
                                                                    "assets/alarm.mp3",
                                                                enableNotificationOnKill:
                                                                    true,
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
                                                    onPressed: () async => {
                                                          await Alarm.stop(
                                                              index)
                                                        },
                                                    icon: const Icon(
                                                        Icons.alarm_off),
                                                    color: Colors.red[900])
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                });
                          }
                        }),
                    floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.add,
                            size: 30, color: Colors.white),
                        onPressed: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddPatientPage(),
                                ),
                              ),
                            }),
                  )),
              const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: ActivePatientsPage(),
              )
            ],
          ),
        ));
  }
}
