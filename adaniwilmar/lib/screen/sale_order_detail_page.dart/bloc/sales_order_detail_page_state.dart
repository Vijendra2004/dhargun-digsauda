import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/lifting_detail_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SalesOrderDetailPageState extends Equatable {
  const SalesOrderDetailPageState();
  @override
  List<Object> get props => [];
}

class InitialSalesOrderDetailPageState extends SalesOrderDetailPageState {}

class ShowProgressBar extends SalesOrderDetailPageState {}

class HideProgressBar extends SalesOrderDetailPageState {}

class OnSuccess extends SalesOrderDetailPageState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SalesOrderDetailPageState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SalesOrderDetailPageState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SalesOrderDetailPageState {
  final LiftingDetailResponse liftingDetail;
  const OnLoadSuccess({required this.liftingDetail});

  @override
  // TODO: implement props
  List<Object> get props => [liftingDetail];
}
class OnApprovalSuccess extends SalesOrderDetailPageState {
  final bool saved;
  const OnApprovalSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}
