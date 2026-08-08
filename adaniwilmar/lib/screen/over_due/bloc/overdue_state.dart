import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class OverDueState extends Equatable {
  const OverDueState();
  @override
  List<Object> get props => [];
}

class InitialOverDueState extends OverDueState {}

class ShowProgressBar extends OverDueState {}

class HideProgressBar extends OverDueState {}

class OnSuccess extends OverDueState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends OverDueState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends OverDueState {
  final DueForTomorrowList response;
  final int statusId;
  const OnOverallSuccess({required this.response,required this.statusId});

  @override
  // TODO: implement props
  List<Object> get props => [response,statusId];
}

class OnLoadSuccess extends OverDueState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}
