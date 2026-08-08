import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/deviation_add_request.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class NewDeviationRequestState extends Equatable {
  const NewDeviationRequestState();
  @override
  List<Object> get props => [];
}

class InitialNewDeviationRequestState extends NewDeviationRequestState {}

class ShowProgressBar extends NewDeviationRequestState {}

class HideProgressBar extends NewDeviationRequestState {}

class OnSuccess extends NewDeviationRequestState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends NewDeviationRequestState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends NewDeviationRequestState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends NewDeviationRequestState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadDealerSaudaDetail extends NewDeviationRequestState {
  final DealerSaudaDetail dealerSaudaDetail;
  final List<SKUPricing> skuDetail;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail, required this.skuDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail, skuDetail];
}

class OnLoadDeviationReason extends NewDeviationRequestState {
  final List<DeviationReason> deviationReasonList;
  const OnLoadDeviationReason({required this.deviationReasonList});

  @override
  // TODO: implement props
  List<Object> get props => [deviationReasonList];
}

class OnLoadApprovedTourPlan extends NewDeviationRequestState {
  final List<ApprovedMtp> approvedTourPlan;
  const OnLoadApprovedTourPlan({required this.approvedTourPlan});

  @override
  // TODO: implement props
  List<Object> get props => [approvedTourPlan];
}

class OnLoadTourPlanDetailList extends NewDeviationRequestState {
  final List<TourPlanDetail> tourPlanDetail;
  const OnLoadTourPlanDetailList({required this.tourPlanDetail});

  @override
  // TODO: implement props
  List<Object> get props => [tourPlanDetail];
}

class OnLoadIncoTerms extends NewDeviationRequestState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends NewDeviationRequestState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadSKUDetails extends NewDeviationRequestState {
  final List<SKUPricing> skuList;
  final bool isPopup;
  const OnLoadSKUDetails({required this.skuList, required this.isPopup});

  @override
  // TODO: implement props
  List<Object> get props => [skuList, isPopup];
}

class OnLoadOilType extends NewDeviationRequestState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSaveDeviation extends NewDeviationRequestState {
  final DeviationAddResponse response;
  const OnSaveDeviation({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnRateChange extends NewDeviationRequestState {
  final bool change;

  const OnRateChange({required this.change});

  @override
  // TODO: implement props
  List<Object> get props => [change];
}
