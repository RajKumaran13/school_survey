import 'package:hive/hive.dart';

part 'schoold_data_hive.g.dart';

@HiveType(typeId: 1)
class SchoolData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  @HiveField(2)
  List<String> curriculum;

  @HiveField(3)
  DateTime establishedOn;

  @HiveField(4)
  List<String> grades;

  SchoolData({
    required this.name,
    required this.type,
    required this.curriculum,
    required this.establishedOn,
    required this.grades,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'curriculum': curriculum,
      'establishedOn': establishedOn.toIso8601String(),
      'grades': grades,
    };
  }

  factory SchoolData.fromMap(Map<String, dynamic> map) {
    return SchoolData(
      name: map['name'],
      type: map['type'],
      curriculum: List<String>.from(map['curriculum']),
      establishedOn: DateTime.parse(map['establishedOn']),
      grades: List<String>.from(map['grades']),
    );
  }
}
