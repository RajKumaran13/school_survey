import 'package:hive/hive.dart';

part 'general_data_hive.g.dart';

@HiveType(typeId: 2)
class GeneralData extends HiveObject {
  @HiveField(0)
  String areaName;

  @HiveField(1)
  int totalSchools;

  GeneralData({required this.areaName, required this.totalSchools});

  Map<String, dynamic> toMap() => {
        'areaName': areaName,
        'totalSchools': totalSchools,
      };

  factory GeneralData.fromMap(Map<String, dynamic> map) {
    return GeneralData(
      areaName: map['areaName'],
      totalSchools: map['totalSchools'],
    );
  }
}
