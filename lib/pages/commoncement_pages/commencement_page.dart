

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:school_survey/common/date_picker.dart';
import 'package:school_survey/common/multi_selected_form.dart';
import 'package:school_survey/common/top_bar.dart';
import 'package:school_survey/pages/commoncement_pages/model/general_data.dart';
import 'dart:async';

import 'package:school_survey/pages/commoncement_pages/model/school_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommencementPage extends StatefulWidget {
  const CommencementPage({Key? key}) : super(key: key);

  @override
  _CommencementPageState createState() => _CommencementPageState();
}

class _CommencementPageState extends State<CommencementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  Timer? _debounceTimer;
  
  int _currentIndex = 0;
  GeneralData _generalData = GeneralData(areaName: '', totalSchools: 0);
  List<SchoolData> _schoolsData = [];
  
  final List<String> _schoolTypes = ['Public', 'Private', 'Govt Aided', 'Special'];
  final List<String> _curriculumOptions = ['CBSE', 'ICSE', 'IB', 'State Board'];
  final List<String> _gradeOptions = ['Primary', 'Secondary', 'Higher Secondary'];
  
  @override
  void initState() {
    super.initState();
    _schoolsData.add(SchoolData(
      name: '',
      type: '',
      curriculum: [],
      establishedOn: DateTime.now(),
      grades: [],
    ));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
  Future<void> _saveToSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> schoolJsonList = _schoolsData.map((e) => e.toJson()).toList();
  await prefs.setStringList('school_data_list', schoolJsonList);
}

  void _saveData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    
    _formKey.currentState!.save();
    
    try {
      final surveyDoc = _firestore.collection('surveyData').doc();
      
      await surveyDoc.collection('generalData').doc('info').set(
        _generalData.toMap(),
      );
      
      for (int i = 0; i < _schoolsData.length; i++) {
        await surveyDoc.collection('schools').doc('school_$i').set(
          _schoolsData[i].toMap(),
        );
      }
      await _saveToSharedPreferences();
      
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  void _updateSchoolCount(int num) {
    if (num >= 1 && num <= 5) {
      setState(() {
        _generalData.totalSchools = num;
        
        while (_schoolsData.length < num) {
          _schoolsData.add(SchoolData(
            name: '', // Always start with empty name
            type: '',
            curriculum: [],
            establishedOn: DateTime.now(),
            grades: [],
          ));
        }
        
        while (_schoolsData.length > num) {
          _schoolsData.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Row(
        children: [
          Container(
            width: 150,
            color: Colors.black,
            child: ListView(
              children: [
                _buildSidebarButton(0, 'General Data'),
                for (int i = 1; i <= _generalData.totalSchools; i++)
                  _buildSidebarButton(i, 'School-$i'),
                if (_generalData.totalSchools > 0 && 
                    _currentIndex == _generalData.totalSchools)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _saveData,
                      child: const Text('Finish'),
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _currentIndex == 0 
                    ? _buildGeneralDataForm()
                    : _buildSchoolForm(_currentIndex - 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildSidebarButton(int index, String title) {
  final bool isSelected = _currentIndex == index;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: isSelected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: isSelected ? Colors.black : Colors.purple,
        ),
      ),
      onTap: () {
        if (index == 0 || index <= _generalData.totalSchools) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    ),
  );
}


  Widget _buildGeneralDataForm() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'General Data',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Name of the Area',
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: _generalData.areaName),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter area name';
          }
          return null;
        },
        onChanged: (value) {
          _generalData.areaName = value ?? '';
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Total No. of Schools (Max 5)',
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(
          text: _generalData.totalSchools > 0 
              ? _generalData.totalSchools.toString() 
              : '',
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter number of schools';
          }
          final num = int.tryParse(value);
          if (num == null || num < 1 || num > 5) {
            return 'Please enter a number between 1 and 5';
          }
          return null;
        },
        onChanged: (value) {
          if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
          
          _debounceTimer = Timer(const Duration(milliseconds: 300), () {
            final num = int.tryParse(value) ?? 0;
            _updateSchoolCount(num);
          });
        },
      ),
    ],
  );
}

  Widget _buildSchoolForm(int schoolIndex) {
    if (schoolIndex >= _schoolsData.length) {
      return const Center(child: Text('Invalid school index'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'School ${schoolIndex + 1} Data',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Name of the School',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: _schoolsData[schoolIndex].name),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter school name';
            }
            return null;
          },
          onChanged: (value) {
            _schoolsData[schoolIndex].name = value ?? '';
          },
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Type of the school',
            border: OutlineInputBorder(),
          ),
          items: _schoolTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select school type';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _schoolsData[schoolIndex].type = value!;
            });
          },
          value: _schoolsData[schoolIndex].type.isEmpty 
              ? null 
              : _schoolsData[schoolIndex].type,
        ),
        const SizedBox(height: 20),
        MultiSelectFormField(
          title: 'Curriculum',
          options: _curriculumOptions,
          selectedValues: _schoolsData[schoolIndex].curriculum,
          onChanged: (values) {
            setState(() {
              _schoolsData[schoolIndex].curriculum = values;
            });
          },
          validator: (values) {
            if (values == null || values.isEmpty) {
              return 'Please select at least one curriculum';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        DatePickerFormField(
          labelText: 'Established on',
          initialDate: _schoolsData[schoolIndex].establishedOn,
          onDateSelected: (date) {
            setState(() {
              _schoolsData[schoolIndex].establishedOn = date;
            });
          },
          validator: (date) {
            if (date == null) {
              return 'Please select establishment date';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        MultiSelectFormField(
          title: 'Grades Present in the school',
          options: _gradeOptions,
          selectedValues: _schoolsData[schoolIndex].grades,
          onChanged: (values) {
            setState(() {
              _schoolsData[schoolIndex].grades = values;
            });
          },
          validator: (values) {
            if (values == null || values.isEmpty) {
              return 'Please select at least one grade';
            }
            return null;
          },
        ),
      ],
    );
  }
}


