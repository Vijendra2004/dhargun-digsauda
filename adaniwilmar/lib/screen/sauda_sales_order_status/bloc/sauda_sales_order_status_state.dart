import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/lifting_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaSalesOrderStatusState extends Equatable {
  const SaudaSalesOrderStatusState();
  @override
  List<Object> get props => [];
}

class InitialSaudaSalesOrderStatusState extends SaudaSalesOrderStatusState {}

class ShowProgressBar extends SaudaSalesOrderStatusState {}

class HideProgressBar extends SaudaSalesOrderStatusState {}

class OnSuccess extends SaudaSalesOrderStatusState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaSalesOrderStatusState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaSalesOrderStatusState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaSalesOrderStatusState {
  final List<LiftingResponse> liftingResponse;
  final int statusId;
  const OnLoadSuccess({required this.liftingResponse,required this.statusId});

  @override
  // TODO: implement props
  List<Object> get props => [liftingResponse,statusId];
}

class OnLoadDealerSuccess extends SaudaSalesOrderStatusState {
  final List<DealerLiftingResponse> liftingResponse;
  final int statusId;
  const OnLoadDealerSuccess({required this.liftingResponse,required this.statusId});

  @override
  // TODO: implement props
  List<Object> get props => [liftingResponse,statusId];
}
