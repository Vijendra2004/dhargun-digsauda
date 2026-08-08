import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class StpState extends Equatable {
  const StpState();
  @override
  List<Object> get props => [];
}

class InitialStpState extends StpState {}

class ShowProgressBar extends StpState {}

class HideProgressBar extends StpState {}

class OnSuccess extends StpState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends StpState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends StpState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends StpState {
  final List<SalesTourPlanChartViewDto> chartData;
  const OnLoadSuccess({required this.chartData});

  @override
  // TODO: implement props
  List<Object> get props => [chartData];
}
