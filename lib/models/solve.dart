import 'package:hive/hive.dart';

@HiveType()
class Solve extends HiveObject {
  @HiveField(0)
  int date;

  @HiveField(1)
  String practicing;

  @HiveField(2)
  String scramble;

  @HiveField(3)
  int inspectionTime;

  @HiveField(4)
  int solveTime;

  @HiveField(5)
  bool plus2S;

  @HiveField(6)
  bool dnf;
}