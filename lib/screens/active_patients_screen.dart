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
  String searchText = '';
  final TextEditingController _nameController = TextEditingController();
  DateTime now = DateTime.now();

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
              if (box.isEmpty) {
                return const Center(
                  child: Text("Aucun patient actif"),
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 5.0),
                      child: SearchBar(
                        elevation: MaterialStateProperty.all(2.0),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) =>
                                const Color.fromARGB(255, 231, 231, 231)),
                        textStyle: MaterialStateTextStyle.resolveWith(
                            (states) => const TextStyle(color: Colors.black54)),
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        leading: const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.black54,
                        ),
                        hintText: "Rechercher un patient",
                        hintStyle:
                            MaterialStateProperty.resolveWith<TextStyle?>(
                          (states) {
                            return const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final patient = box.getAt(index) as Patient;
                            if (patient.isActive) {
                              if (searchText.isEmpty ||
                                  patient.name
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) ||
                                  patient.age.toString().contains(searchText)) {
                                return Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(patient.name +
                                            " / " +
                                            patient.age.toString() +
                                            " ans"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Switch.adaptive(
                                              activeColor: Colors.green,
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
                                      ListView.builder(
                                          itemCount: patient.exercises?.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(patient
                                                  .exercises[index].name),
                                              subtitle: Text(patient
                                                  .exercises[index].duration
                                                  .toString()),
                                            );
                                          }),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
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
                                                              now.minute + 2),
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
                                              onPressed: () async =>
                                                  {await Alarm.stop(index)},
                                              icon: const Icon(Icons.alarm_off),
                                              color: Colors.red[900])
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return const SizedBox.shrink();
                            }
                            return null;
                          }),
                    ),
                  ],
                );
              }
            }));
  }
}
