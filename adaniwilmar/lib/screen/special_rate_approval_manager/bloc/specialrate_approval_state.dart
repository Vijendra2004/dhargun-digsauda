import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SpecialRateApprovalManagerState extends Equatable {
  const SpecialRateApprovalManagerState();
  @override
  List<Object> get props => [];
}

class InitialSpecialRateApprovalManagerState
    extends SpecialRateApprovalManagerState {}

class ShowProgressBar extends SpecialRateApprovalManagerState {}

class HideProgressBar extends SpecialRateApprovalManagerState {}

class OnSuccess extends SpecialRateApprovalManagerState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SpecialRateApprovalManagerState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SpecialRateApprovalManagerState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SpecialRateApprovalManagerState {
  final List<SpecialRateList> specialRateList;
  const OnLoadSuccess({required this.specialRateList});

  @override
  // TODO: implement props
  List<Object> get props => [specialRateList];
}

class OnLoadBdoList extends SpecialRateApprovalManagerState {
  final List<BdoList> bdoList;
  const OnLoadBdoList({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}

class OnSaveSuccess extends SpecialRateApprovalManagerState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}
class OnLoadSalesOrganization extends SpecialRateApprovalManagerState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends SpecialRateApprovalManagerState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends SpecialRateApprovalManagerState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}
