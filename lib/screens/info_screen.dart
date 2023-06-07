// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:MyPatient/models/patient.dart';
import 'package:MyPatient/screens/active_patients_screen.dart';
import 'package:MyPatient/screens/add_exercice_screen.dart';
import 'package:MyPatient/screens/add_patient_screen.dart';
import 'package:MyPatient/screens/exercices_list_screen.dart';
import 'package:MyPatient/screens/update_patient_screen.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late final Box patientsBox;
  late final Box exerciseBox;
  bool value = false;
  String searchText = '';
  final _nameController = TextEditingController();

  _deleteInfo(int index) async {
    await patientsBox.deleteAt(index);
    print('Deleted successfully');
  }

  @override
  void initState() {
    super.initState();
    patientsBox = Hive.box('patients');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                Tab(
                  icon: Icon(Icons.sports_gymnastics),
                  text: 'exercises',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                      body: ValueListenableBuilder(
                          valueListenable: patientsBox.listenable(),
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
                                      elevation: MaterialStateProperty.all(2.0),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(
                                                  255, 231, 231, 231)),
                                      textStyle:
                                          MaterialStateTextStyle.resolveWith(
                                              (states) => const TextStyle(
                                                  color: Colors.black54)),
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Dismissible(
                                                        confirmDismiss:
                                                            (direction) async {
                                                          if (direction ==
                                                              DismissDirection
                                                                  .endToStart) {
                                                            return await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    elevation:
                                                                        5,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .warning,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 30,
                                                                    ),
                                                                    title: const Text(
                                                                        'Supprimer'),
                                                                    content:
                                                                        const Text(
                                                                            'Voulez-vous supprimer ce patient?'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              false),
                                                                          child:
                                                                              const Text('NON')),
                                                                      TextButton(
                                                                          onPressed: () =>
                                                                              {
                                                                                _deleteInfo(index),
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                  showCloseIcon: true,
                                                                                  behavior: SnackBarBehavior.floating,
                                                                                  closeIconColor: Colors.white,
                                                                                  content: Text('Patient supprimé'),
                                                                                  duration: Duration(seconds: 2),
                                                                                )),
                                                                                Navigator.pop(context, true)
                                                                              },
                                                                          child:
                                                                              const Text('OUI')),
                                                                    ],
                                                                  );
                                                                });
                                                          } else {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            UpdatePatientPage(
                                                                              index: index,
                                                                              patient: patient,
                                                                            )));
                                                            return false;
                                                          }
                                                        },
                                                        secondaryBackground:
                                                            Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15),
                                                          color: Colors.red,
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        ),
                                                        background: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15),
                                                          color: Colors.green,
                                                          child: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        ),
                                                        key: UniqueKey(),
                                                        child: Card(
                                                          surfaceTintColor:
                                                              Colors.green,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          elevation: 4,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(11.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${patient.name} / ${patient.age} ans",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 8.0),
                                                                          child: Text(
                                                                              "Présent?",
                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                                                                        ),
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
                                                                  ],
                                                                ),
                                                                const Divider(
                                                                  height: 0,
                                                                  thickness: 1,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0.0,
                                                                          12.0,
                                                                          0.0,
                                                                          12.0),
                                                                  child: Text(
                                                                      "Maladie: ${patient.disease}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black87)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ))),
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              );
                            }
                          }),
                      floatingActionButton: SpeedDial(
                        animatedIcon: AnimatedIcons.menu_close,
                        backgroundColor: Colors.green,
                        children: [
                          SpeedDialChild(
                            child: const Icon(Icons.add),
                            label: "Ajouter un patient",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddPatientPage())),
                          ),
                          SpeedDialChild(
                            child: const Icon(Icons.add),
                            label: "Ajouter un Exercice",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddExercicePage())),
                          ),
                        ],
                      ))),
              const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: ActivePatientsPage(),
              ),
              const MaterialApp(
                  debugShowCheckedModeBanner: false, home: exercisesListPage()),
            ],
          ),
        ));
  }
}
