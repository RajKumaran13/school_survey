import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:school_survey/features/with_held_survey_page/model/with_held_survey_api.dart';

part 'with_held_survey_store.g.dart';

class WithheldSurveyStore = _WithheldSurveyStore with _$WithheldSurveyStore;

abstract class _WithheldSurveyStore with Store {
  final WithheldSurveyApi _api = WithheldSurveyApi();

  @observable
  Stream<QuerySnapshot>? withheldSurveysStream;

  @observable
  String? errorMessage;

  @action
  void fetchWithheldSurveys() {
    try {
      withheldSurveysStream = _api.getWithheldSurveysStream();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
