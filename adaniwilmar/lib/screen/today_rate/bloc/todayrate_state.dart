import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sauda_booking_status.dart';

abstract class TodayRateState extends Equatable {
  const TodayRateState();
  @override
  List<Object> get props => [];
}

class InitialTodayRateState extends TodayRateState {}

class ShowProgressBar extends TodayRateState {}

class HideProgressBar extends TodayRateState {}

class OnSuccess extends TodayRateState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends TodayRateState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
class OnLoadDealerSaudaDetail extends TodayRateState {
  final DealerSaudaDetail dealerSaudaDetail;
  const OnLoadDealerSaudaDetail(
      {required this.dealerSaudaDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerSaudaDetail];
}


class OnOverallSuccess extends TodayRateState {
  final List<DailyRate> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends TodayRateState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadStates extends TodayRateState {
  final List<ActiveState> states;
  const OnLoadStates({required this.states});

  @override
  // TODO: implement props
  List<Object> get props => [states];
}

class OnLoadSalesOrganization extends TodayRateState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends TodayRateState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends TodayRateState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadIncoTerms extends TodayRateState {
  final List<IncoTerms> incoTerms;
  const OnLoadIncoTerms({required this.incoTerms});

  @override
  // TODO: implement props
  List<Object> get props => [incoTerms];
}

class OnLoadPlant extends TodayRateState {
  final List<PlanDepotList> plantList;
  const OnLoadPlant({required this.plantList});

  @override
  // TODO: implement props
  List<Object> get props => [plantList];
}

class OnLoadOilType extends TodayRateState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}


class GetTodayRateBooking extends TodayRateState {
  final SaudaBookingStatus todayRateBookingStatus;

  const GetTodayRateBooking({required this.todayRateBookingStatus});

  @override
  // TODO: implement props
  List<Object> get props => [todayRateBookingStatus];
}
