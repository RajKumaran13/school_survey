class GeneralData {
  String areaName;
  int totalSchools;

  GeneralData({
    required this.areaName,
    required this.totalSchools,
  });

  Map<String, dynamic> toMap() {
    return {
      'areaName': areaName,
      'totalSchools': totalSchools,
    };
  }

  factory GeneralData.fromMap(Map<String, dynamic> map) {
    return GeneralData(
      areaName: map['areaName'] ?? '',
      totalSchools: map['totalSchools'] ?? 0,
    );
  }
}
