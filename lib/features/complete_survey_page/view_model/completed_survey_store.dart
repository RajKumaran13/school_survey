import 'dart:convert';  // Add this import to decode the JSON string.
import 'package:mobx/mobx.dart';
import 'package:school_survey/features/commencement_page/model/schood.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'completed_survey_store.g.dart';

class SchoolDataStore = _SchoolDataStore with _$SchoolDataStore;

abstract class _SchoolDataStore with Store {
  @observable
  ObservableList<SchoolData> schoolList = ObservableList<SchoolData>();

  @action
  Future<void> loadSchoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? schoolJsonList = prefs.getStringList('school_data_list');
    if (schoolJsonList != null) {
      schoolList = ObservableList.of(schoolJsonList.map((e) => SchoolData.fromJson(e)).toList());
    }
  }
}  
