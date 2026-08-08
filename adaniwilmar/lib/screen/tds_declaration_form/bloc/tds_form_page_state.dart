import 'package:adaniwilmar/models/TdsFormModel.dart';
import 'package:equatable/equatable.dart';

class TdsFormPageState extends Equatable {
  const TdsFormPageState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TdsFormPageInitial extends TdsFormPageState {
  @override
  List<Object> get props => [];
}

class LoadTdsFormProgressBar extends TdsFormPageState {}

class DisableTdsFormProgressBar extends TdsFormPageState {}

class OnTdsFormPageSuccess extends TdsFormPageState {
  final List<TdsFormResponse> response;
  const OnTdsFormPageSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnTdsFormFailure extends TdsFormPageState {
  final String error;

  const OnTdsFormFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

