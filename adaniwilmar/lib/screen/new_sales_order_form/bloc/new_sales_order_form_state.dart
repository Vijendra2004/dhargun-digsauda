import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/contract_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/filler_sku_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/skulist_response.dart';
import 'package:adaniwilmar/models/vehicle_size_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class NewSalesOrderState extends Equatable {
  const NewSalesOrderState();
  @override
  List<Object> get props => [];
}

class InitialNewSalesOrderState extends NewSalesOrderState {}

class ShowProgressBar extends NewSalesOrderState {}

class HideProgressBar extends NewSalesOrderState {}

class OnSuccess extends NewSalesOrderState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends NewSalesOrderState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends NewSalesOrderState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends NewSalesOrderState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadDealerSalesOrderDetail extends NewSalesOrderState {
  final DealerSaudaDetail dealerSalesOrderDetail;
  final List<SKUPricing> skuDetail;
  const OnLoadDealerSalesOrderDetail(
      {required this.dealerSalesOrderDetail, required this.skuDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSalesOrderDetail, skuDetail];
}

class OnLoadDefaults extends NewSalesOrderState {
  final DefaultInputResponse defaults;
  const OnLoadDefaults({required this.defaults});

  @override
  // TODO: implement props
  List<Object> get props => [defaults];
}

class OnLoadSalesOrganization extends NewSalesOrderState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends NewSalesOrderState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends NewSalesOrderState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadShipToParty extends NewSalesOrderState {
  final List<DistributorList> shipToParty;
  final List<VehicleSize> vehicleSize;
  final List<Contract> contracts;
  const OnLoadShipToParty({required this.shipToParty,required this.vehicleSize,required this.contracts});

  @override
  // TODO: implement props
  List<Object> get props => [shipToParty,vehicleSize,contracts];
}

class OnLoadIncoTerms extends NewSalesOrderState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends NewSalesOrderState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends NewSalesOrderState {
  final List<SKUList> skuList;
  final bool isPopup;
  const OnLoadSKUDetails({required this.skuList, required this.isPopup});

  @override
  // TODO: implement props
  List<Object> get props => [skuList, isPopup];
}

class OnLoadFillerSKUDetails extends NewSalesOrderState {
  final List<FillerSKU> skuList;
  const OnLoadFillerSKUDetails({required this.skuList});

  @override
  // TODO: implement props
  List<Object> get props => [skuList];
}

class OnLoadOilType extends NewSalesOrderState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSaveSalesOrder extends NewSalesOrderState {
  final String message;
  const OnSaveSalesOrder({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class OnRateChange extends NewSalesOrderState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
class OnLoadBDO extends NewSalesOrderState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}
class OnLoadContract extends NewSalesOrderState {
  final List<Contract> contracts;
  const OnLoadContract({required this.contracts});

  @override
  // TODO: implement props
  List<Object> get props => [contracts];
}
