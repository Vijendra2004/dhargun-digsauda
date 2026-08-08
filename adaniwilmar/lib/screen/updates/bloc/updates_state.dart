import 'package:adaniwilmar/models/customer_ledger_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/latest_update_response.dart';
import 'package:equatable/equatable.dart';

abstract class UpdatesState extends Equatable {
  const UpdatesState();
  @override
  List<Object> get props => [];
}

class InitialUpdatesState extends UpdatesState {}

class ShowProgressBar extends UpdatesState {}

class HideProgressBar extends UpdatesState {}

// class OnSuccess extends UpdatesState {
//   final WeeklyResponse response;
//   const OnSuccess({required this.response});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [response];
// }

class OnFailure extends UpdatesState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

// class OnOverallSuccess extends UpdatesState {
//   final DueForTomorrowList response;
//   const OnOverallSuccess({required this.response});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [response];
// }

class OnLoadSuccess extends UpdatesState {
  final List<LatestUpdateResponse> updates;
  const OnLoadSuccess(
      {required this.updates});

  @override
  // TODO: implement props
  List<Object> get props => [updates];
}

class OnLedgerDataSuccess extends UpdatesState {
  final LedgerInfo ledgerInfo;
  const OnLedgerDataSuccess({required this.ledgerInfo});

  @override
  // TODO: implement props
  List<Object> get props => [ledgerInfo];
}
