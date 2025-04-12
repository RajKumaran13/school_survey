
import 'dart:convert';

class SchoolData {
  String name;
  String type;
  List<String> curriculum;
  DateTime establishedOn;
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
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      curriculum: List<String>.from(map['curriculum'] ?? []),
      establishedOn: DateTime.parse(map['establishedOn']),
      grades: List<String>.from(map['grades'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory SchoolData.fromJson(String source) => SchoolData.fromMap(json.decode(source));
}

// class SchoolData {
//   String name;
//   String type;
//   List<String> curriculum;
//   DateTime establishedOn;
//   List<String> grades;

//   SchoolData({
//     required this.name,
//     required this.type,
//     required this.curriculum,
//     required this.establishedOn,
//     required this.grades,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'type': type,
//       'curriculum': curriculum,
//       'establishedOn': establishedOn.toIso8601String(),
//       'grades': grades,
//     };
//   }

//   factory SchoolData.fromMap(Map<String, dynamic> map) {
//     return SchoolData(
//       name: map['name'] ?? '',
//       type: map['type'] ?? '',
//       curriculum: List<String>.from(map['curriculum'] ?? []),
//       establishedOn: DateTime.parse(map['establishedOn']),
//       grades: List<String>.from(map['grades'] ?? []),
//     );
//   }
// }