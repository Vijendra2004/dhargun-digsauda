import 'package:equatable/equatable.dart';

import '../../../models/TdsFormModel.dart';

class MoreScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoreScreenInitial extends MoreScreenState {}

class OnSuccessLoggedOut extends MoreScreenState {

}

class FormPageSuccess extends MoreScreenState {
  final List<TdsFormResponse> response;

  FormPageSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class TanNumberSuccess extends MoreScreenState {
  final String response;

  TanNumberSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class TanNumberUpdateSuccess extends MoreScreenState {
  final String response;

  TanNumberUpdateSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class ShowProgress extends MoreScreenState {}

class HideProgress extends MoreScreenState {}
