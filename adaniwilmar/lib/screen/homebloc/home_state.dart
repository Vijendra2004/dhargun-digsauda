import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/overall_response.dart';
import 'package:adaniwilmar/models/statistics_response.dart';
import 'package:adaniwilmar/models/ticker_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class InitialHomeState extends HomeState {}

class ShowProgressBar extends HomeState {}

class HideProgressBar extends HomeState {}

class NotifyScreenState extends HomeState {}

class OnSuccess extends HomeState {
  final WeeklyResponse response;
  final WeeklySalesResponse salesResponse;
  final List<TickerList> tickerList;
  const OnSuccess(
      {required this.response,
      required this.salesResponse,
      required this.tickerList});

  @override
  // TODO: implement props
  List<Object> get props => [response, salesResponse, tickerList];
}

class OnFailure extends HomeState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends HomeState {
  final OverallDashboard response;
  final OverallDashboard salesResponse;
  const OnOverallSuccess({required this.response, required this.salesResponse});

  @override
  // TODO: implement props
  List<Object> get props => [response, salesResponse];
}

class OnStatisticsSuccess extends HomeState {
  final StatisticsResponse response;
  final List<DistributorList> distributorList;
  const OnStatisticsSuccess(
      {required this.response, required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [response, distributorList];
}


class onLastAliveTimeSuccess extends HomeState {

  const onLastAliveTimeSuccess();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

