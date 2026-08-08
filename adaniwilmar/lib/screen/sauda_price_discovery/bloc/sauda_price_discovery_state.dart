import 'package:adaniwilmar/models/competitor_list.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaPriceDiscoveryState extends Equatable {
  const SaudaPriceDiscoveryState();
  @override
  List<Object> get props => [];
}

class InitialSaudaPriceDiscoveryState extends SaudaPriceDiscoveryState {}

class ShowProgressBar extends SaudaPriceDiscoveryState {}

class HideProgressBar extends SaudaPriceDiscoveryState {}

class OnSuccess extends SaudaPriceDiscoveryState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaPriceDiscoveryState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaPriceDiscoveryState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaPriceDiscoveryState {
  final List<CompetitorList> competitorList;
  const OnLoadSuccess({required this.competitorList});

  @override
  // TODO: implement props
  List<Object> get props => [competitorList];
}

class OnLoadDealerSaudaDetail extends SaudaPriceDiscoveryState {
  final DealerSaudaDetail dealerSaudaDetail;
  final List<SKUPricing> skuDetail;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail, required this.skuDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail, skuDetail];
}

class OnLoadSalesOrganization extends SaudaPriceDiscoveryState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends SaudaPriceDiscoveryState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends SaudaPriceDiscoveryState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadIncoTerms extends SaudaPriceDiscoveryState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends SaudaPriceDiscoveryState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends SaudaPriceDiscoveryState {
  final List<OilTypeSkuList> skuList;
  final int currentIndex;
  const OnLoadSKUDetails({required this.skuList, required this.currentIndex});

  @override
  // TODO: implement props
  List<Object> get props => [skuList, currentIndex];
}

class OnLoadOilType extends SaudaPriceDiscoveryState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSavePriceDiscovery extends SaudaPriceDiscoveryState {
  final String response;
  const OnSavePriceDiscovery({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnRateChange extends SaudaPriceDiscoveryState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
