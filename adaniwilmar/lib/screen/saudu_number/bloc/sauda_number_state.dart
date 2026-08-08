import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:equatable/equatable.dart';
import '../../../models/special_rate_view_response.dart';

abstract class SaudaNumberState extends Equatable {
  const SaudaNumberState();
  @override
  List<Object> get props => [];
}

class InitialSaudaNumberState extends SaudaNumberState {}

class ShowProgressBar extends SaudaNumberState {}

class HideProgressBar extends SaudaNumberState {}

class OnSuccess extends SaudaNumberState {
  final SpecialRateView response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaNumberState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaNumberState {
  final SpecialRateView response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaNumberState {
  final List<SpecialRate> sprateInfo;
  const OnLoadSuccess({required this.sprateInfo});

  @override
  // TODO: implement props
  List<Object> get props => [sprateInfo];
}
