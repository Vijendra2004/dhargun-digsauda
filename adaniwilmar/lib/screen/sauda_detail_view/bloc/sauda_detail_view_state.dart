import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaDetailViewState extends Equatable {
  const SaudaDetailViewState();
  @override
  List<Object> get props => [];
}

class InitialSaudaDetailViewState extends SaudaDetailViewState {}

class ShowProgressBar extends SaudaDetailViewState {}

class HideProgressBar extends SaudaDetailViewState {}

class OnSuccess extends SaudaDetailViewState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaDetailViewState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaDetailViewState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaDetailViewState {
  final SaudaDetailResponse saudaDetailResponse;
  const OnLoadSuccess({required this.saudaDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [saudaDetailResponse];
}
