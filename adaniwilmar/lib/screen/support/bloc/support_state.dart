import 'package:adaniwilmar/models/customer_ledger_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/models/support_list_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SupportState extends Equatable {
  const SupportState();
  @override
  List<Object> get props => [];
}

class InitialSupportState extends SupportState {}

class ShowProgressBar extends SupportState {}

class HideProgressBar extends SupportState {}

class OnSuccess extends SupportState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SupportState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnNewSupportSuccess extends SupportState {
  final SupportMaster response;
  const OnNewSupportSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SupportState {
  final List<SupportList> supportData;
  OnLoadSuccess({required this.supportData});

  @override
  // TODO: implement props
  List<Object> get props => [supportData];
}
class OnSaveSuccess extends SupportState {
  final String response;
  const OnSaveSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}