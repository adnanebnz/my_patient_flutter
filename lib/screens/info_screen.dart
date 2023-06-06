// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myPatient/models/patient.dart';
import 'package:myPatient/screens/active_patients_screen.dart';
import 'package:myPatient/screens/add_patient_screen.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late final Box box;
  bool value = false;
  String searchText = '';
  final _nameController = TextEditingController();
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
            title: const Text('Acceuil'),
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
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 12.0, 12.0, 5.0),
                                  child: SearchBar(
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
                                    hintStyle: MaterialStateProperty
                                        .resolveWith<TextStyle?>(
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
                                        var patient =
                                            box.getAt(index) as Patient;
                                        return Column(
                                          children: [
                                            if (searchText.isEmpty ||
                                                patient.name
                                                    .toLowerCase()
                                                    .contains(searchText
                                                        .toLowerCase()) ||
                                                patient.age
                                                    .toString()
                                                    .contains(searchText))
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Card(
                                                    surfaceTintColor:
                                                        Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    elevation: 4,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    patient
                                                                        .name,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    patient.age
                                                                            .toString() +
                                                                        " ans",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                        8.0),
                                                                child: Switch
                                                                    .adaptive(
                                                                        value: patient
                                                                            .isActive,
                                                                        onChanged: (value) =>
                                                                            {
                                                                              setState(() {
                                                                                patient.isActive = value;
                                                                              })
                                                                            })),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  10.0),
                                                          child: Text(
                                                              "Maladie: " +
                                                                  patient
                                                                      .disease,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black87)),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                          ],
                                        );
                                      }),
                                ),
                              ],
                            );
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
