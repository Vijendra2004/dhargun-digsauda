import 'package:adaniwilmar/models/EssentialSkuMapping.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/qps_req_model.dart';
import 'package:adaniwilmar/models/qps_res_model.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sauda_booking_status.dart';

abstract class NewSaudaState extends Equatable {
  const NewSaudaState();
  @override
  List<Object> get props => [];
}

class InitialNewSaudaState extends NewSaudaState {}

class ShowProgressBar extends NewSaudaState {}

class HideProgressBar extends NewSaudaState {}

class OnSuccess extends NewSaudaState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends NewSaudaState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends NewSaudaState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends NewSaudaState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadDealerSaudaDetail extends NewSaudaState {
  final DealerSaudaDetail dealerSaudaDetail;
  final List<SKUPricing> skuDetail;
  final bool loadLimit;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail, required this.skuDetail,required this.loadLimit});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail, skuDetail,loadLimit];
}

class OnLoadDefaults extends NewSaudaState {
  final DefaultInputResponse defaults;
  const OnLoadDefaults({required this.defaults});

  @override
  // TODO: implement props
  List<Object> get props => [defaults];
}

class OnLoadSalesOrganization extends NewSaudaState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends NewSaudaState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends NewSaudaState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadIncoTerms extends NewSaudaState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends NewSaudaState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends NewSaudaState {
  final List<SKUPricing> skuList;
  final bool isPopup;
  const OnLoadSKUDetails({required this.skuList, required this.isPopup});

  @override
  // TODO: implement props
  List<Object> get props => [skuList, isPopup];
}

class OnLoadOilType extends NewSaudaState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnMandatory extends NewSaudaState {
  final List<Response> mandatorySku;
  const OnMandatory({required this.mandatorySku});

  @override
  // TODO: implement props
  List<Object> get props => [mandatorySku];
}

class OnSaveSauda extends NewSaudaState {
  final int id;
  const OnSaveSauda({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class OnRateChange extends NewSaudaState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
class OnLoadBDO extends NewSaudaState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}


class LoadSaudaRestriction extends NewSaudaState {
  const LoadSaudaRestriction();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class OnGetSaudaBooking extends NewSaudaState {
   SaudaBookingStatus saudaBookingStatus = SaudaBookingStatus();

   OnGetSaudaBooking({required this.saudaBookingStatus});

  @override
  // TODO: implement props
  List<Object> get props => [saudaBookingStatus];
}


class LoadQPS extends NewSaudaState {
  List<QPSResponseData> qpsResModel = <QPSResponseData>[];
  List<SkuDetails> qpsReqModel = <SkuDetails>[];
  bool isAlertTriggered = false;

  LoadQPS( {required this.qpsResModel,  this. isAlertTriggered = false, required this.qpsReqModel});

  @override
  // TODO: implement props
  List<Object> get props => [qpsResModel,isAlertTriggered,qpsReqModel];
}


// This is coming from alert save
class LoadQPSDiscount extends NewSaudaState {
  List<QPSResponseData> qpsResModel = <QPSResponseData>[];
  LoadQPSDiscount({required this.qpsResModel});

  @override
  // TODO: implement props
  List<Object> get props => [qpsResModel];
}


class LoadRemoveQPS extends NewSaudaState {}



