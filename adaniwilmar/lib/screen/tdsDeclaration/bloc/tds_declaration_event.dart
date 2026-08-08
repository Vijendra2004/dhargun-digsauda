import 'package:equatable/equatable.dart';

import '../../../models/SubmitRequestModel.dart';

class TdsDeclarationEvent extends Equatable {
  const TdsDeclarationEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TdsQuestionsApiCall extends TdsDeclarationEvent {
  dynamic formId = "";
  TdsQuestionsApiCall({required dynamic formId});

  @override
  // TODO: implement props
  List<Object> get props => [formId];
}

class RadioSelectionChanged extends TdsDeclarationEvent {
  final String selectedValue;

  const RadioSelectionChanged(this.selectedValue);

  @override
  List<Object?> get props => [selectedValue];
}

class SurveyQuestionSubmit extends TdsDeclarationEvent {
  final SubmitRequestModel requestModel;

  const SurveyQuestionSubmit(this.requestModel);

  @override
  List<Object?> get props => [requestModel];
}
