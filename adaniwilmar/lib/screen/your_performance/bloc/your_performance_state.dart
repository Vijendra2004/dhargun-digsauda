import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:adaniwilmar/models/your_sales_performance_response.dart';
import 'package:equatable/equatable.dart';

abstract class YourPerformanceState extends Equatable {
  const YourPerformanceState();
  @override
  List<Object> get props => [];
}

class InitialYourPerformanceState extends YourPerformanceState {}

class ShowProgressBar extends YourPerformanceState {}

class HideProgressBar extends YourPerformanceState {}

class OnSuccess extends YourPerformanceState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends YourPerformanceState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends YourPerformanceState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends YourPerformanceState {
  final YourSalesPerformance salesPerformance;
  final List<YourSalesPerformance> rankingList;
  const OnLoadSuccess(
      {required this.salesPerformance, required this.rankingList});

  @override
  // TODO: implement props
  List<Object> get props => [salesPerformance, rankingList];
}
