import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_history.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class AllocationState extends Equatable {
  const AllocationState();
  @override
  List<Object> get props => [];
}

class InitialAllocationState extends AllocationState {}

class ShowProgressBar extends AllocationState {}

class HideProgressBar extends AllocationState {}

class OnSuccess extends AllocationState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends AllocationState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends AllocationState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends AllocationState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadDealerSaudaDetail extends AllocationState {
  final DealerSaudaDetail dealerSaudaDetail;
  final List<SKUPricing> skuDetail;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail, required this.skuDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail, skuDetail];
}

class OnLoadSalesOrganization extends AllocationState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends AllocationState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends AllocationState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadIncoTerms extends AllocationState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends AllocationState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends AllocationState {
  final List<BdoList> skuList;
  const OnLoadSKUDetails({required this.skuList});

  @override
  // TODO: implement props
  List<Object> get props => [skuList];
}
class OnLoadZhList extends AllocationState {
  final List<BdoList> zhList;
  const OnLoadZhList({required this.zhList});

  @override
  // TODO: implement props
  List<Object> get props => [zhList];
}


class OnLoadOilType extends AllocationState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSaveQuantityLimit extends AllocationState {
  final String id;
  const OnSaveQuantityLimit({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class OnRateChange extends AllocationState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
class OnLoadHistorySuccess extends AllocationState {
  final List<LimitEnhancementHistory> limitRequests;
  const OnLoadHistorySuccess({required this.limitRequests});

  @override
  // TODO: implement props
  List<Object> get props => [limitRequests];
}

class OnLoadDealerHistorySuccess extends AllocationState {
  final List<Saudahistory> limitRequests;
  const OnLoadDealerHistorySuccess({required this.limitRequests});

  @override
  // TODO: implement props
  List<Object> get props => [limitRequests];
}
class OnUpdateQuantityLimitData extends AllocationState {
  final List<QuantityRequestList> response;
  const OnUpdateQuantityLimitData({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnUserQuantityLimitData extends AllocationState {
  final List<QuantityRequestList> response;
  const OnUserQuantityLimitData({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}
