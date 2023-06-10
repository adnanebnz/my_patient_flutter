import 'package:MyPatient/utils/CancelScheduleDialog.dart';
import 'package:MyPatient/utils/ScheduleDialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MyPatient/models/patient.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  late final Box patientBox;

  String searchText = '';
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    patientBox = Hive.box('patients');
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

          if (activePatients.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text(
                  "Aucun patient n'est actif",
                ),
              ),
            );
          }

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
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                          ),
                          Text(
                            "Maladie: ${patient.disease}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
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
