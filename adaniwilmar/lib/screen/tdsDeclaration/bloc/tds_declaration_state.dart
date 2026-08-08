import 'dart:collection';

import 'package:adaniwilmar/models/TdsQuestionsModelData.dart';
import 'package:equatable/equatable.dart';

class TdsDeclarationState extends Equatable {
  const TdsDeclarationState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadProgressBar extends TdsDeclarationState {}

class DisableProgressBar extends TdsDeclarationState {}

class OnFailure extends TdsDeclarationState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class LoadQuestionData extends TdsDeclarationState {
  final TdsQuestionModelResponse response;
  const LoadQuestionData({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetSubmitResponse extends TdsDeclarationState {
  final String response;
  const GetSubmitResponse({required this.response});

  @override
  List<Object?> get props => [response];
}


class RadioSelected extends TdsDeclarationState {
  final String selectedValue;

  const RadioSelected(this.selectedValue);

  @override
  List<Object?> get props => [selectedValue];
}

class TdsQuestionsGetResponseModel extends TdsDeclarationState {
  final TdsQuestionsGetResponseModel response;

  const TdsQuestionsGetResponseModel({required this.response});

  @override
  List<Object> get props => [response];
}

class TdsDeclarationInitial extends TdsDeclarationState {
  @override
  List<Object> get props => [];
}
