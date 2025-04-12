import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_survey/features/add_survey_page/model/add_survey_api.dart';

part 'add_survey_store.g.dart';

class SurveyFormStore = _SurveyFormStore with _$SurveyFormStore;

abstract class _SurveyFormStore with Store {
  final SurveyApi api = SurveyApi();

  @observable
  String name = '';

  @observable
  String reference = '';

  @observable
  String description = '';

  @observable
  String assignedTo = '';

  @observable
  String assignedBy = '';

  @observable
  DateTime? startDate;

  @observable
  DateTime? dueDate;

  @observable
  bool isLoading = true;

  @action
  void setName(String value) => name = value;

  @action
  void setReference(String value) => reference = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setAssignedTo(String value) => assignedTo = value;

  @action
  void setStartDate(DateTime? date) => startDate = date;

  @action
  void setDueDate(DateTime? date) => dueDate = date;

  @action
  Future<void> loadAssignedBy() async {
    assignedBy = await api.getAssignedBy();
    isLoading = false;
  }

  @action
  void generateReferenceNumber() {
    final random = Random();
    reference = 'REF${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  @action
  void populateSurveyData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    name = data['name'] ?? '';
    reference = data['reference'] ?? '';
    description = data['description'] ?? '';
    assignedTo = data['assigned_to'] ?? '';
    startDate = data['commencement_date'] != null ? DateTime.parse(data['commencement_date']) : null;
    dueDate = data['due_date'] != null ? DateTime.parse(data['due_date']) : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'reference': reference.trim(),
      'description': description.trim(),
      'commencement_date': startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : null,
      'due_date': dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : null,
      'assigned_to': assignedTo.trim(),
      'assigned_by': assignedBy,
      'updated_at': Timestamp.now(),
    };
  }

  Future<void> saveSurvey() => api.saveSurvey(toMap());

  Future<void> updateSurvey(String docId) => api.updateSurvey(docId, toMap());
}
