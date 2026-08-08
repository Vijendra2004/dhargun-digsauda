import 'package:adaniwilmar/models/credit_limit_total.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SalesState extends Equatable {
  const SalesState();
  @override
  List<Object> get props => [];
}

class InitialSalesState extends SalesState {}

class ShowProgressBar extends SalesState {}

class HideProgressBar extends SalesState {}

class OnSuccess extends SalesState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SalesState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadSuccess extends SalesState {
  final CreditLimitTotal creditLimitTotal;
  const OnLoadSuccess({required this.creditLimitTotal});

  @override
  // TODO: implement props
  List<Object> get props => [creditLimitTotal];
}

class OnLoadChartSuccess extends SalesState {
  final SalesChartResponse salesChartData;
  const OnLoadChartSuccess({required this.salesChartData});

  @override
  // TODO: implement props
  List<Object> get props => [salesChartData];
}

class OnLoadDealerSalesSuccess extends SalesState {
  final DealerSalesChartResponse salesChartData;
  const OnLoadDealerSalesSuccess({required this.salesChartData});

  @override
  // TODO: implement props
  List<Object> get props => [salesChartData];
}
