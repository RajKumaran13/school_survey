// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shedule_survey_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScheduledSurveyStore on _ScheduledSurveyStore, Store {
  late final _$scheduledSurveysStreamAtom = Atom(
      name: '_ScheduledSurveyStore.scheduledSurveysStream', context: context);

  @override
  Stream<QuerySnapshot<Object?>>? get scheduledSurveysStream {
    _$scheduledSurveysStreamAtom.reportRead();
    return super.scheduledSurveysStream;
  }

  @override
  set scheduledSurveysStream(Stream<QuerySnapshot<Object?>>? value) {
    _$scheduledSurveysStreamAtom
        .reportWrite(value, super.scheduledSurveysStream, () {
      super.scheduledSurveysStream = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ScheduledSurveyStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$deleteSurveyAsyncAction =
      AsyncAction('_ScheduledSurveyStore.deleteSurvey', context: context);

  @override
  Future<void> deleteSurvey(DocumentSnapshot<Object?> doc) {
    return _$deleteSurveyAsyncAction.run(() => super.deleteSurvey(doc));
  }

  late final _$_ScheduledSurveyStoreActionController =
      ActionController(name: '_ScheduledSurveyStore', context: context);

  @override
  void fetchScheduledSurveys() {
    final _$actionInfo = _$_ScheduledSurveyStoreActionController.startAction(
        name: '_ScheduledSurveyStore.fetchScheduledSurveys');
    try {
      return super.fetchScheduledSurveys();
    } finally {
      _$_ScheduledSurveyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scheduledSurveysStream: ${scheduledSurveysStream},
errorMessage: ${errorMessage}
    ''';
  }
}
