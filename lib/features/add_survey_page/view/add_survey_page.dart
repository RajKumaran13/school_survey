import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:school_survey/common/top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_survey/features/add_survey_page/view_model/add_survey_store.dart';
import 'package:school_survey/utils/colors.dart';

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
  final SurveyFormStore store = SurveyFormStore();

  @override
  void initState() {
    super.initState();
    store.loadAssignedBy();
    if (widget.isEditing && widget.surveyData != null) {
      store.populateSurveyData(widget.surveyData!);
    } else {
      store.generateReferenceNumber();
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
      if (isStartDate) {
        store.setStartDate(picked);
      } else {
        store.setDueDate(picked);
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.isEditing && widget.surveyData != null) {
        await store.updateSurvey(widget.surveyData!.id);
        Fluttertoast.showToast(
          msg: 'Survey updated',
          backgroundColor: Colors.green,
          textColor: AppColors.primaryWhite,
        );
      } else {
        await store.saveSurvey();
        Fluttertoast.showToast(
          msg: 'Survey saved',
          backgroundColor: Colors.green,
          textColor: AppColors.primaryWhite,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        textColor: AppColors.primaryWhite,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => store.isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
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
                        color: AppColors.primaryPurple.withOpacity(0.3),
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
                          initialValue: store.name,
                          style: const TextStyle(color: AppColors.primaryWhite),
                          decoration: _buildInputDecoration('Survey Name'),
                          validator: (value) => value!.isEmpty ? 'Please enter survey name' : null,
                          onChanged: store.setName,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: store.reference,
                          readOnly: true,
                          style: const TextStyle(color: Colors.white70),
                          decoration: _buildInputDecoration('Reference Number'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: store.description,
                          maxLines: 4,
                          style: const TextStyle(color: AppColors.primaryWhite),
                          decoration: _buildInputDecoration('Detailed Description'),
                          validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                          onChanged: store.setDescription,
                        ),
                        _buildSectionTitle('Timeline'),
                        _buildDateTile('Date of Commencement', store.startDate, () => _pickDate(context, true)),
                        _buildDateTile('Due Date', store.dueDate, () => _pickDate(context, false)),
                        _buildSectionTitle('Assignment'),
                        TextFormField(
                          initialValue: store.assignedTo,
                          style: const TextStyle(color: AppColors.primaryWhite),
                          decoration: _buildInputDecoration('Assigned To'),
                          validator: (value) => value!.isEmpty ? 'Please enter assignee' : null,
                          onChanged: store.setAssignedTo,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: store.assignedBy,
                          readOnly: true,
                          style: const TextStyle(color: Colors.white70),
                          decoration: _buildInputDecoration('Assigned By'),
                        ),
                        const SizedBox(height: 24), 
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _submit,
                            icon: Icon(widget.isEditing ? Icons.update : Icons.save, color: AppColors.primaryWhite, size: 20),
                            label: Text(
                              widget.isEditing ? 'Update Survey' : 'Save Survey',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryWhite),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryWhite),
      ),
    );
  }

  Widget _buildDateTile(String label, DateTime? date, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
      subtitle: Text(
        date != null ? DateFormat('dd MMM yyyy').format(date) : 'Tap to select date',
        style: const TextStyle(color: AppColors.primaryWhite),
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
