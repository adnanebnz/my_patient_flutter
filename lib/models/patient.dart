import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'patient.g.dart';

@HiveType(typeId: 1)
class Patient {
  @HiveField(0)
  String name;
  @HiveField(1)
  String age;
  @HiveField(2)
  String exercise;
  @HiveField(3)
  String duration;

  Patient(
      {required this.name,
      required this.age,
      required this.exercise,
      required this.duration});
}
