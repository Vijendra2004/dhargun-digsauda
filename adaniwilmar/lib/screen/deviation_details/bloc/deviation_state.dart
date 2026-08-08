import 'package:adaniwilmar/models/deviation_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class DeviationState extends Equatable {
  const DeviationState();
  @override
  List<Object> get props => [];
}

class InitialDeviationState extends DeviationState {}

class ShowProgressBar extends DeviationState {}

class HideProgressBar extends DeviationState {}

class OnSuccess extends DeviationState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends DeviationState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends DeviationState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends DeviationState {
  final List<DeviationResponse> deviationList;
  final List<DeviationResponse> pendingDeviationList;
  const OnLoadSuccess(
      {required this.deviationList, required this.pendingDeviationList});

  @override
  // TODO: implement props
  List<Object> get props => [deviationList, pendingDeviationList];
}
