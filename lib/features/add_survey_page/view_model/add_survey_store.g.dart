// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_survey_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SurveyFormStore on _SurveyFormStore, Store {
  late final _$nameAtom = Atom(name: '_SurveyFormStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$referenceAtom =
      Atom(name: '_SurveyFormStore.reference', context: context);

  @override
  String get reference {
    _$referenceAtom.reportRead();
    return super.reference;
  }

  @override
  set reference(String value) {
    _$referenceAtom.reportWrite(value, super.reference, () {
      super.reference = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: '_SurveyFormStore.description', context: context);

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$assignedToAtom =
      Atom(name: '_SurveyFormStore.assignedTo', context: context);

  @override
  String get assignedTo {
    _$assignedToAtom.reportRead();
    return super.assignedTo;
  }

  @override
  set assignedTo(String value) {
    _$assignedToAtom.reportWrite(value, super.assignedTo, () {
      super.assignedTo = value;
    });
  }

  late final _$assignedByAtom =
      Atom(name: '_SurveyFormStore.assignedBy', context: context);

  @override
  String get assignedBy {
    _$assignedByAtom.reportRead();
    return super.assignedBy;
  }

  @override
  set assignedBy(String value) {
    _$assignedByAtom.reportWrite(value, super.assignedBy, () {
      super.assignedBy = value;
    });
  }

  late final _$startDateAtom =
      Atom(name: '_SurveyFormStore.startDate', context: context);

  @override
  DateTime? get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(DateTime? value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  late final _$dueDateAtom =
      Atom(name: '_SurveyFormStore.dueDate', context: context);

  @override
  DateTime? get dueDate {
    _$dueDateAtom.reportRead();
    return super.dueDate;
  }

  @override
  set dueDate(DateTime? value) {
    _$dueDateAtom.reportWrite(value, super.dueDate, () {
      super.dueDate = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_SurveyFormStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$loadAssignedByAsyncAction =
      AsyncAction('_SurveyFormStore.loadAssignedBy', context: context);

  @override
  Future<void> loadAssignedBy() {
    return _$loadAssignedByAsyncAction.run(() => super.loadAssignedBy());
  }

  late final _$_SurveyFormStoreActionController =
      ActionController(name: '_SurveyFormStore', context: context);

  @override
  void setName(String value) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReference(String value) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.setReference');
    try {
      return super.setReference(value);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAssignedTo(String value) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.setAssignedTo');
    try {
      return super.setAssignedTo(value);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDate(DateTime? date) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.setStartDate');
    try {
      return super.setStartDate(date);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDueDate(DateTime? date) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.setDueDate');
    try {
      return super.setDueDate(date);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void generateReferenceNumber() {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.generateReferenceNumber');
    try {
      return super.generateReferenceNumber();
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void populateSurveyData(DocumentSnapshot<Object?> doc) {
    final _$actionInfo = _$_SurveyFormStoreActionController.startAction(
        name: '_SurveyFormStore.populateSurveyData');
    try {
      return super.populateSurveyData(doc);
    } finally {
      _$_SurveyFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
reference: ${reference},
description: ${description},
assignedTo: ${assignedTo},
assignedBy: ${assignedBy},
startDate: ${startDate},
dueDate: ${dueDate},
isLoading: ${isLoading}
    ''';
  }
}
