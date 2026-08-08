import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SecondarySalesDetailState extends Equatable {
  const SecondarySalesDetailState();
  @override
  List<Object> get props => [];
}

class InitialSecondarySalesDetailState extends SecondarySalesDetailState {}

class ShowProgressBar extends SecondarySalesDetailState {}

class HideProgressBar extends SecondarySalesDetailState {}

class OnSuccess extends SecondarySalesDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SecondarySalesDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SecondarySalesDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SecondarySalesDetailState {
  final List<SecondarySalesFortheDayDetailViewDto> secondarySalesDetail;
  const OnLoadSuccess({required this.secondarySalesDetail});

  @override
  // TODO: implement props
  List<Object> get props => [secondarySalesDetail];
}
