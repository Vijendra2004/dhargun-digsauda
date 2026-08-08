import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SalesOrderDetailState extends Equatable {
  const SalesOrderDetailState();
  @override
  List<Object> get props => [];
}

class InitialSalesOrderDetailState extends SalesOrderDetailState {}

class ShowProgressBar extends SalesOrderDetailState {}

class HideProgressBar extends SalesOrderDetailState {}

class OnSuccess extends SalesOrderDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SalesOrderDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SalesOrderDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SalesOrderDetailState {
  final List<DealerLiftingResponse> dealerLiftingResponse;
  const OnLoadSuccess({required this.dealerLiftingResponse});

  @override
  // TODO: implement props
  List<Object> get props => [dealerLiftingResponse];
}
