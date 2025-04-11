import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:school_survey/pages/commoncement_pages/model/school_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolDataListPage extends StatefulWidget {
  const SchoolDataListPage({Key? key}) : super(key: key);

  @override
  _SchoolDataListPageState createState() => _SchoolDataListPageState();
}

class _SchoolDataListPageState extends State<SchoolDataListPage> {
  List<SchoolData> _schoolList = [];

  @override
  void initState() {
    super.initState();
    _loadSchoolData();
  }

  Future<void> _loadSchoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? schoolJsonList = prefs.getStringList('school_data_list');

    if (schoolJsonList != null) {
      setState(() {
        _schoolList = schoolJsonList.map((e) => SchoolData.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _schoolList.isEmpty
          ? const Center(
              child: Text(
                'No school data found',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _schoolList.length,
              itemBuilder: (context, index) {
                final school = _schoolList[index];
                return Container(
  margin: const EdgeInsets.only(bottom: 14),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
      colors: [
        Colors.purple.withOpacity(0.2),
        Colors.black.withOpacity(0.3),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.purple.withOpacity(0.4),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
    border: Border.all(color: Colors.white.withOpacity(0.2)),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              school.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _infoRow('Type', school.type),
            _infoRow('Established', school.establishedOn.toLocal().toString().split(' ')[0]),
            _infoRow('Curriculum', school.curriculum.join(', ')),
            _infoRow('Grades', school.grades.join(', ')),
          ],
        ),
      ),
    ),
  ),
);
              },
            ),
    );
    
  }
  Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

}


// import 'package:flutter/material.dart';
// import 'package:school_survey/pages/commoncement_pages/model/school_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class SchoolDataListPage extends StatefulWidget {
//   const SchoolDataListPage({Key? key}) : super(key: key);

//   @override
//   _SchoolDataListPageState createState() => _SchoolDataListPageState();
// }

// class _SchoolDataListPageState extends State<SchoolDataListPage> {
//   List<SchoolData> _schoolList = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSchoolData();
//   }

//   Future<void> _loadSchoolData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String>? schoolJsonList = prefs.getStringList('school_data_list');

//     if (schoolJsonList != null) {
//       setState(() {
//         _schoolList = schoolJsonList.map((e) => SchoolData.fromJson(e)).toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _schoolList.isEmpty
//           ? const Center(child: Text('No school data found'))
//           : ListView.builder(
//               itemCount: _schoolList.length,
//               itemBuilder: (context, index) {
//                 final school = _schoolList[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(school.name),
//                     subtitle: Text(
//                       'Type: ${school.type}\n'
//                       'Established On: ${school.establishedOn.toLocal().toString().split(' ')[0]}\n'
//                       'Curriculum: ${school.curriculum.join(', ')}\n'
//                       'Grades: ${school.grades.join(', ')}',
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
