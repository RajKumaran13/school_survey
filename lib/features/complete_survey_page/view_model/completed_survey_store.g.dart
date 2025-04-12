// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_survey_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SchoolDataStore on _SchoolDataStore, Store {
  late final _$schoolListAtom =
      Atom(name: '_SchoolDataStore.schoolList', context: context);

  @override
  ObservableList<SchoolData> get schoolList {
    _$schoolListAtom.reportRead();
    return super.schoolList;
  }

  @override
  set schoolList(ObservableList<SchoolData> value) {
    _$schoolListAtom.reportWrite(value, super.schoolList, () {
      super.schoolList = value;
    });
  }

  late final _$loadSchoolDataAsyncAction =
      AsyncAction('_SchoolDataStore.loadSchoolData', context: context);

  @override
  Future<void> loadSchoolData() {
    return _$loadSchoolDataAsyncAction.run(() => super.loadSchoolData());
  }

  @override
  String toString() {
    return '''
schoolList: ${schoolList}
    ''';
  }
}
