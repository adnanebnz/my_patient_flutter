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
  @HiveField(5)
  List<Exercise?>? selectedExercises;

  Patient(
      {required this.name,
      required this.exercises,
      this.selectedExercises,
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
  @HiveField(2)
  bool? isDone = false;
  @HiveField(3)
  String? description;

  Exercise(
      {required this.name,
      required this.duration,
      this.isDone,
      this.description});
}
