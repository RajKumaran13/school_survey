import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:school_survey/features/shedule_survey_page/model/shedule_survey_api.dart';

part 'shedule_survey_store.g.dart';

class ScheduledSurveyStore = _ScheduledSurveyStore with _$ScheduledSurveyStore;

abstract class _ScheduledSurveyStore with Store {
  final ScheduledSurveyApi _api = ScheduledSurveyApi();

  @observable
  Stream<QuerySnapshot>? scheduledSurveysStream;

  @observable
  String? errorMessage;

  @action
  void fetchScheduledSurveys() {
    try {
      scheduledSurveysStream = _api.getScheduledSurveysStream();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> deleteSurvey(DocumentSnapshot doc) async {
    try {
      await _api.moveToWithheldAndDelete(doc);
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
