import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myPatient/models/patient.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  late final Box box;

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
                        child: ListTile(
                          title: Text(patient.name),
                          subtitle: Text(patient.age.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _deleteInfo(index);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  });
            }));
  }
}
