import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:MyPatient/models/patient.dart';
import 'package:MyPatient/screens/update_exercise_screen.dart';

// ignore: camel_case_types
class exercisesListPage extends StatefulWidget {
  const exercisesListPage({super.key});

  @override
  State<exercisesListPage> createState() => _exercisesListPageState();
}

// ignore: camel_case_types
class _exercisesListPageState extends State<exercisesListPage> {
  late final Box exercisesBox;
  String searchText = '';
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exercisesBox = Hive.box('exercises');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: exercisesBox.listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) {
                return const Center(
                  child: Text("Aucun exercice n'a été ajouté"),
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
                        hintText: "Rechercher un exercice",
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
                            final exercice = box.getAt(index) as Exercise;
                            if (searchText.isEmpty ||
                                exercice.name
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()) ||
                                exercice.duration
                                    .toString()
                                    .contains(searchText)) {
                              return Dismissible(
                                key: UniqueKey(),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            elevation: 5,
                                            icon: const Icon(
                                              Icons.warning,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            title: const Text(
                                                "Supprimer l'exercice"),
                                            content: const Text(
                                                "Voulez-vous vraiment supprimer cet exercice ?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("NON")),
                                              TextButton(
                                                  onPressed: () {
                                                    box.deleteAt(index);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Oui")),
                                            ],
                                          );
                                        });
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateExercisePage(
                                                  index: index,
                                                  exercise: exercice,
                                                )));
                                    return false;
                                  }
                                  return null;
                                },
                                secondaryBackground: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 15),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 15),
                                  color: Colors.green,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                child: Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(exercice.name),
                                        subtitle: Text(
                                            "Description : ${exercice.description}"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                    ),
                  ],
                );
              }
            }));
  }
}
