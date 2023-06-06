import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myPatient/models/patient.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  late final Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('patients');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ValueListenableBuilder(valueListenable: box.listenable(), builder: (context,box,widget)=>{
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final patient = box.getAt(index) as Patient;
            return ListTile(
              title: Text(patient.name),
              subtitle: Text(patient.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  box.deleteAt(index);
                },
              ),
            );
          },
        );
      })
      ),
    );
  }
}
