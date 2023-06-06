import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String age;
  @HiveField(2)
  String disease;
  @HiveField(3)
  bool isActive = false;
  @HiveField(4)
  List<Exercise?>? exercises;

  Patient(
      {required this.name,
      required this.exercises,
      required this.age,
      required this.isActive,
      required this.disease});
}

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String duration;

  Exercise({required this.name, required this.duration});
}
