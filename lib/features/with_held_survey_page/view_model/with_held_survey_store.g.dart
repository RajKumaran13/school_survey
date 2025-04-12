// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'with_held_survey_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WithheldSurveyStore on _WithheldSurveyStore, Store {
  late final _$withheldSurveysStreamAtom = Atom(
      name: '_WithheldSurveyStore.withheldSurveysStream', context: context);

  @override
  Stream<QuerySnapshot<Object?>>? get withheldSurveysStream {
    _$withheldSurveysStreamAtom.reportRead();
    return super.withheldSurveysStream;
  }

  @override
  set withheldSurveysStream(Stream<QuerySnapshot<Object?>>? value) {
    _$withheldSurveysStreamAtom.reportWrite(value, super.withheldSurveysStream,
        () {
      super.withheldSurveysStream = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_WithheldSurveyStore.errorMessage', context: context);

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

  late final _$_WithheldSurveyStoreActionController =
      ActionController(name: '_WithheldSurveyStore', context: context);

  @override
  void fetchWithheldSurveys() {
    final _$actionInfo = _$_WithheldSurveyStoreActionController.startAction(
        name: '_WithheldSurveyStore.fetchWithheldSurveys');
    try {
      return super.fetchWithheldSurveys();
    } finally {
      _$_WithheldSurveyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
withheldSurveysStream: ${withheldSurveysStream},
errorMessage: ${errorMessage}
    ''';
  }
}
