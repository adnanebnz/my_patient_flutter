// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learning_hive/models/patient.dart';
import 'package:learning_hive/screens/add_patient_screen.dart';
import 'package:learning_hive/screens/update_patient_screen.dart';
import 'package:alarm/alarm.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late final Box box;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations'),
      ),
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
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 4,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    "${patient.name} / ${patient.age} ans",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(patient.exercise.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdatePatientPage(
                                                          index: index,
                                                          patient: patient)));
                                        },
                                        icon: const Icon(Icons.edit),
                                        color: Colors.blue[600]),
                                    IconButton(
                                      onPressed: () {
                                        _deleteInfo(index);
                                      },
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red[900],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Mouvement: ${patient.exercise}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  IconButton(
                                    onPressed: () async => {
                                      await Alarm.set(
                                          alarmSettings: AlarmSettings(
                                              id: index,
                                              dateTime: DateTime(2023,
                                                  DateTime.june, 5, 16, 50, 00),
                                              assetAudioPath:
                                                  "assets/alarm.mp3"))
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
                              )
                            ],
                          ),
                        ));
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
          onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddPatientPage(),
                  ),
                ),
              }),
    );
  }
}
