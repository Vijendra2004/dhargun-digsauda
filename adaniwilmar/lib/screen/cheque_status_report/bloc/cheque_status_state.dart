import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/cheque_pending_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class ChequeStatusState extends Equatable {
  const ChequeStatusState();
  @override
  List<Object> get props => [];
}

class InitialChequeStatusState extends ChequeStatusState {}

class ShowProgressBar extends ChequeStatusState {}

class HideProgressBar extends ChequeStatusState {}

class OnSuccess extends ChequeStatusState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends ChequeStatusState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends ChequeStatusState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends ChequeStatusState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadSalesOrganization extends ChequeStatusState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends ChequeStatusState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends ChequeStatusState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadBDO extends ChequeStatusState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}

class OnChequeStatusDataSuccess extends ChequeStatusState {
  final List<ChequePending> chequePendingStatus;
  const OnChequeStatusDataSuccess({required this.chequePendingStatus});

  @override
  // TODO: implement props
  List<Object> get props => [chequePendingStatus];
}
