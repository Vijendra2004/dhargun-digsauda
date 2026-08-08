import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/pending_contract_filter_response.dart';
import 'package:adaniwilmar/models/pending_contract_report_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class PendingContractState extends Equatable {
  const PendingContractState();
  @override
  List<Object> get props => [];
}

class InitialPendingContractState extends PendingContractState {}

class ShowProgressBar extends PendingContractState {}

class HideProgressBar extends PendingContractState {}

class OnSuccess extends PendingContractState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PendingContractState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends PendingContractState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends PendingContractState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadSalesOrganization extends PendingContractState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends PendingContractState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends PendingContractState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadBDO extends PendingContractState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}

class OnPendingContractFilterSuccess extends PendingContractState {
  final PendingContractFilterValue pendingContractFilters;
  const OnPendingContractFilterSuccess({required this.pendingContractFilters});

  @override
  // TODO: implement props
  List<Object> get props => [pendingContractFilters];
}

class OnPendingContractDataSuccess extends PendingContractState {
  final PendingContractReport pendingContractData;
  const OnPendingContractDataSuccess({required this.pendingContractData});

  @override
  // TODO: implement props
  List<Object> get props => [pendingContractData];
}

class OnLoadStates extends PendingContractState {
  final List<ActiveState> states;
  const OnLoadStates({required this.states});

  @override
  // TODO: implement props
  List<Object> get props => [states];
}
