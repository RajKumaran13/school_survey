import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:school_survey/common/top_bar.dart';

class AddSurveyPage extends StatefulWidget {
  final DocumentSnapshot? surveyData;
  final bool isEditing;

  const AddSurveyPage({
    super.key,
    this.surveyData,
    this.isEditing = false,
  });

  @override
  State<AddSurveyPage> createState() => _AddSurveyPageState();
}

class _AddSurveyPageState extends State<AddSurveyPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _refNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  DateTime? _startDate;
  DateTime? _dueDate;

  String _assignedBy = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateReferenceNumber();
    _loadAssignedBy();
    if (widget.isEditing && widget.surveyData != null) {
      _populateSurveyData(widget.surveyData!);
    }
  }

  void _generateReferenceNumber() {
    if (!widget.isEditing) {
      final random = Random();
      final ref = 'REF${random.nextInt(999999).toString().padLeft(6, '0')}';
      _refNumberController.text = ref;
    }
  }

  void _populateSurveyData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    _nameController.text = data['name'] ?? '';
    _refNumberController.text = data['reference'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _assignedToController.text = data['assigned_to'] ?? '';
    _startDate = data['commencement_date'] != null
        ? DateTime.parse(data['commencement_date'])
        : null;
    _dueDate = data['due_date'] != null
        ? DateTime.parse(data['due_date'])
        : null;
  }

  Future<void> _loadAssignedBy() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final name = doc.data()?['name'] ?? 'User';
      setState(() {
        _assignedBy = name;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _saveSurvey() async {
    if (!_formKey.currentState!.validate()) return;

    final surveyData = {
      'name': _nameController.text.trim(),
      'reference': _refNumberController.text.trim(),
      'description': _descriptionController.text.trim(),
      'commencement_date': _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
      'due_date': _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : null,
      'assigned_to': _assignedToController.text.trim(),
      'assigned_by': _assignedBy,
      'updated_at': Timestamp.now(),
    };

    try {
      if (widget.isEditing && widget.surveyData != null) {
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection('users').doc(user?.uid)
            .collection('surveys')
            .doc(widget.surveyData!.id)
            .update(surveyData);
        Fluttertoast.showToast(
          msg: 'Survey updated',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        final user = FirebaseAuth.instance.currentUser;
        surveyData['created_at'] = Timestamp.now();
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('surveys').add(surveyData);
        Fluttertoast.showToast(
          msg: 'Survey saved',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: TopBar(),
      backgroundColor: const Color(0xFF1C1B2D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 6),
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Survey Details'),

                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration('Survey Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter survey name' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _refNumberController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white70),
                  decoration: _buildInputDecoration('Reference Number'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration('Detailed Description'),
                  validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                ),

                _buildSectionTitle('Timeline'),
                _buildDateTile('Date of Commencement', _startDate, () => _pickDate(context, true)),
                _buildDateTile('Due Date', _dueDate, () => _pickDate(context, false)),

                _buildSectionTitle('Assignment'),
                TextFormField(
                  controller: _assignedToController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration('Assigned To'),
                  validator: (value) => value!.isEmpty ? 'Please enter assignee' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: _assignedBy,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white70),
                  decoration: _buildInputDecoration('Assigned By'),
                ),
                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveSurvey,
                    icon: Icon(widget.isEditing ? Icons.update : Icons.save, size: 20, color: Colors.white,),
                    label: Text(widget.isEditing ? 'Update Survey' : 'Save Survey', style: TextStyle(fontSize:16, color: Colors.white, fontWeight: FontWeight.w800),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTile(String label, DateTime? date, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        date != null ? DateFormat('dd MMM yyyy').format(date) : 'Tap to select date',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.date_range, color: Colors.white70),
      onTap: onTap,
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}


// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:school_survey/common/top_bar.dart';

// class AddSurveyPage extends StatefulWidget {
//   final DocumentSnapshot? surveyData;
//   final bool isEditing;

//   const AddSurveyPage({
//     super.key,
//     this.surveyData,
//     this.isEditing = false,
//   });

//   @override
//   State<AddSurveyPage> createState() => _AddSurveyPageState();
// }

// class _AddSurveyPageState extends State<AddSurveyPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _refNumberController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _assignedToController = TextEditingController();

//   DateTime? _startDate;
//   DateTime? _dueDate;

//   String _assignedBy = '';
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _generateReferenceNumber();
//     _loadAssignedBy();
//     if (widget.isEditing && widget.surveyData != null) {
//       _populateSurveyData(widget.surveyData!);
//     }
//   }

//   void _generateReferenceNumber() {
//     if (!widget.isEditing) {
//       final random = Random();
//       final ref = 'REF${random.nextInt(999999).toString().padLeft(6, '0')}';
//       _refNumberController.text = ref;
//     }
//   }

//   void _populateSurveyData(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     _nameController.text = data['name'] ?? '';
//     _refNumberController.text = data['reference'] ?? '';
//     _descriptionController.text = data['description'] ?? '';
//     _assignedToController.text = data['assigned_to'] ?? '';
//     _startDate = data['commencement_date'] != null
//         ? DateTime.parse(data['commencement_date'])
//         : null;
//     _dueDate = data['due_date'] != null
//         ? DateTime.parse(data['due_date'])
//         : null;
//   }

//   Future<void> _loadAssignedBy() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       final name = doc.data()?['name'] ?? 'User';
//       setState(() {
//         _assignedBy = name;
//         _isLoading = false;
//       });
//     } else {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _pickDate(BuildContext context, bool isStartDate) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = picked;
//         } else {
//           _dueDate = picked;
//         }
//       });
//     }
//   }

//   void _saveSurvey() async {
//     if (!_formKey.currentState!.validate()) return;

//     final surveyData = {
//       'name': _nameController.text.trim(),
//       'reference': _refNumberController.text.trim(),
//       'description': _descriptionController.text.trim(),
//       'commencement_date': _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
//       'due_date': _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : null,
//       'assigned_to': _assignedToController.text.trim(),
//       'assigned_by': _assignedBy,
//       'updated_at': Timestamp.now(),
//     };

//     try {
//       if (widget.isEditing && widget.surveyData != null) {
//         await FirebaseFirestore.instance
//             .collection('surveys')
//             .doc(widget.surveyData!.id)
//             .update(surveyData);
//         Fluttertoast.showToast(
//           msg: 'Survey updated',
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//       } else {
//         surveyData['created_at'] = Timestamp.now();
//         await FirebaseFirestore.instance.collection('surveys').add(surveyData);
//         Fluttertoast.showToast(
//           msg: 'Survey saved',
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: 'Error: ${e.toString()}',
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: TopBar(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           elevation: 6,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionTitle('Survey Details'),

//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Survey Name',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) => value!.isEmpty ? 'Please enter survey name' : null,
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: _refNumberController,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Reference Number',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: _descriptionController,
//                     maxLines: 4,
//                     decoration: const InputDecoration(
//                       labelText: 'Detailed Description',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) => value!.isEmpty ? 'Please enter description' : null,
//                   ),

//                   _buildSectionTitle('Timeline'),
//                   ListTile(
//                     title: const Text('Date of Commencement'),
//                     subtitle: Text(_startDate != null
//                         ? DateFormat('dd MMM yyyy').format(_startDate!)
//                         : 'Tap to select date'),
//                     trailing: const Icon(Icons.date_range),
//                     onTap: () => _pickDate(context, true),
//                   ),

//                   ListTile(
//                     title: const Text('Due Date'),
//                     subtitle: Text(_dueDate != null
//                         ? DateFormat('dd MMM yyyy').format(_dueDate!)
//                         : 'Tap to select date'),
//                     trailing: const Icon(Icons.date_range),
//                     onTap: () => _pickDate(context, false),
//                   ),

//                   _buildSectionTitle('Assignment'),
//                   TextFormField(
//                     controller: _assignedToController,
//                     decoration: const InputDecoration(
//                       labelText: 'Assigned To',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) => value!.isEmpty ? 'Please enter assignee' : null,
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     initialValue: _assignedBy,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Assigned By',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: _saveSurvey,
//                       icon: Icon(widget.isEditing ? Icons.update : Icons.save),
//                       label: Text(widget.isEditing ? 'Update Survey' : 'Save Survey'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                         textStyle: const TextStyle(fontSize: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }