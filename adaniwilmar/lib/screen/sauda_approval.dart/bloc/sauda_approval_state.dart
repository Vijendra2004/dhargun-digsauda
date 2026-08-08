import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaApprovalState extends Equatable {
  const SaudaApprovalState();
  @override
  List<Object> get props => [];
}

class InitialSaudaApprovalState extends SaudaApprovalState {}

class ShowProgressBar extends SaudaApprovalState {}

class HideProgressBar extends SaudaApprovalState {}

class OnSuccess extends SaudaApprovalState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaApprovalState {
  final String error;
  bool saveError = false;
  OnFailure({required this.error, this.saveError = false});

  @override
  // TODO: implement props
  List<Object> get props => [error, saveError];
}

class OnOverallSuccess extends SaudaApprovalState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaApprovalState {
  final SaudaApprovalList bookedSaudha;
  const OnLoadSuccess({required this.bookedSaudha});

  @override
  // TODO: implement props
  List<Object> get props => [bookedSaudha];
}

class OnLoadSalesOrganization extends SaudaApprovalState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends SaudaApprovalState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends SaudaApprovalState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnSaveSuccess extends SaudaApprovalState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}
