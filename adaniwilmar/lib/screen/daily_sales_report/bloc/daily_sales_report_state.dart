import 'package:adaniwilmar/models/competitor_list.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/today_activity_list.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class DailySalesReportState extends Equatable {
  const DailySalesReportState();
  @override
  List<Object> get props => [];
}

class InitialDailySalesReportState extends DailySalesReportState {}

class ShowProgressBar extends DailySalesReportState {}

class HideProgressBar extends DailySalesReportState {}

class OnSuccess extends DailySalesReportState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends DailySalesReportState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends DailySalesReportState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends DailySalesReportState {
  final List<TodayActivity> activityList;
  final String serverDate;
  const OnLoadSuccess({required this.activityList,required this.serverDate});

  @override
  // TODO: implement props
  List<Object> get props => [activityList,serverDate];
}

class OnLoadDealerVisit extends DailySalesReportState {
  final List<SaudaList> saudaList;
  const OnLoadDealerVisit({required this.saudaList});

  @override
  // TODO: implement props
  List<Object> get props => [saudaList];
}

class OnLoadDealerSaudaDetail extends DailySalesReportState {
  final DealerSaudaDetail dealerSaudaDetail;
  final List<SKUPricing> skuDetail;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail, required this.skuDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail, skuDetail];
}

class OnLoadSalesOrganization extends DailySalesReportState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends DailySalesReportState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends DailySalesReportState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadIncoTerms extends DailySalesReportState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends DailySalesReportState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends DailySalesReportState {
  final List<OilTypeSkuList> skuList;
  final int currentIndex;
  const OnLoadSKUDetails({required this.skuList, required this.currentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [skuList, currentIndex];
}

class OnLoadOilType extends DailySalesReportState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSavePriceDiscovery extends DailySalesReportState {
  final String response;
  const OnSavePriceDiscovery({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnRateChange extends DailySalesReportState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
