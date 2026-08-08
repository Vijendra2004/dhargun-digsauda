import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_history.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaLimitEnhancementState extends Equatable {
  const SaudaLimitEnhancementState();
  @override
  List<Object> get props => [];
}

class InitialSaudaLimitEnhancementState extends SaudaLimitEnhancementState {}

class ShowProgressBar extends SaudaLimitEnhancementState {}

class HideProgressBar extends SaudaLimitEnhancementState {}

class OnSuccess extends SaudaLimitEnhancementState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaLimitEnhancementState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaLimitEnhancementState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaLimitEnhancementState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadDealerSaudaDetail extends SaudaLimitEnhancementState {
  final DealerSaudaDetail dealerSaudaDetail;
  final List<SKUPricing> skuDetail;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail, required this.skuDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail, skuDetail];
}

class OnLoadSalesOrganization extends SaudaLimitEnhancementState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends SaudaLimitEnhancementState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends SaudaLimitEnhancementState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadIncoTerms extends SaudaLimitEnhancementState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends SaudaLimitEnhancementState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends SaudaLimitEnhancementState {
  final List<SKUPricing> skuList;
  final bool isPopup;
  const OnLoadSKUDetails({required this.skuList, required this.isPopup});

  @override
  // TODO: implement props
  List<Object> get props => [skuList, isPopup];
}

class OnLoadOilType extends SaudaLimitEnhancementState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSaveLimitEnhancement extends SaudaLimitEnhancementState {
  final int id;
  const OnSaveLimitEnhancement({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class OnRateChange extends SaudaLimitEnhancementState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
class OnLoadHistorySuccess extends SaudaLimitEnhancementState {
  final List<LimitEnhancementHistory> limitRequests;
  const OnLoadHistorySuccess({required this.limitRequests});

  @override
  // TODO: implement props
  List<Object> get props => [limitRequests];
}

class OnLoadDealerHistorySuccess extends SaudaLimitEnhancementState {
  final List<Saudahistory> limitRequests;
  const OnLoadDealerHistorySuccess({required this.limitRequests});

  @override
  // TODO: implement props
  List<Object> get props => [limitRequests];
}

class OnLoadBDO extends SaudaLimitEnhancementState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}
