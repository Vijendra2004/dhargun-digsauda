import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/pending_contract_filter_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sales_report_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object> get props => [];
}

class InitialReportState extends ReportState {}

class ShowProgressBar extends ReportState {}

class HideProgressBar extends ReportState {}

class OnSuccess extends ReportState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends ReportState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnFailureInReport extends ReportState {
  final String error;

  const OnFailureInReport({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends ReportState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends ReportState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadSalesOrganization extends ReportState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends ReportState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends ReportState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadBDO extends ReportState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}

class OnReportFilterSuccess extends ReportState {
  final PendingContractFilterValue pendingContractFilters;
  const OnReportFilterSuccess({required this.pendingContractFilters});

  @override
  // TODO: implement props
  List<Object> get props => [pendingContractFilters];
}

class OnReportDataSuccess extends ReportState {
  final bool isSales;
  final List<SalesReport> reportData;
  const OnReportDataSuccess({required this.reportData, required this.isSales});

  @override
  // TODO: implement props
  List<Object> get props => [reportData, isSales];
}
class OnNHReportDataSuccess extends ReportState {
  final bool isSales;
  final SaudaNHReport reportData;
  const OnNHReportDataSuccess({required this.reportData, required this.isSales});

  @override
  // TODO: implement props
  List<Object> get props => [reportData, isSales];
}

class OnLoadStates extends ReportState {
  final List<ActiveState> states;
  const OnLoadStates({required this.states});

  @override
  // TODO: implement props
  List<Object> get props => [states];
}

class OnLoadPlant extends ReportState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadOilType extends ReportState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}
