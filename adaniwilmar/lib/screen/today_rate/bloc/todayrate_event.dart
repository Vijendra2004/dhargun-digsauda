import 'package:equatable/equatable.dart';

abstract class TodayRateEvent extends Equatable {
  const TodayRateEvent();

  @override
  List<Object> get props => [];
}

class LoadTodayRateScreen extends TodayRateEvent {
  int userId = 0;

  LoadTodayRateScreen({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadOverallData extends TodayRateEvent {
  int userId = 0;
  int oilTypeId = 0;
  int plantId = 0;
  int verticalId = 0;
  int incoTermId = 0;
  int salesOrgId = 0;
  int distrChannelId = 0;
  LoadOverallData(
      {required this.userId,
      required this.oilTypeId,
      required this.plantId,
      required this.verticalId,
      required this.incoTermId,
      required this.salesOrgId,
      required this.distrChannelId});

  @override
  // TODO: implement props
  List<Object> get props => [
        userId,
        oilTypeId,
        plantId,
        verticalId,
        incoTermId,
        salesOrgId,
        distrChannelId
      ];
}

class LoadStates extends TodayRateEvent {
  int id = 0;
  LoadStates({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadSalesOrganization extends TodayRateEvent {
  int id = 0;
  LoadSalesOrganization({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadDistributionChannel extends TodayRateEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends TodayRateEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends TodayRateEvent {
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int userId = 0;
  LoadOilType(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadIncoTerms extends TodayRateEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends TodayRateEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadUserStatistics extends TodayRateEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class LoadDealerDetail extends TodayRateEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
  LoadDealerDetail(
      {required this.id,
        required this.saudaBookingTypeId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisionId});

  @override
  // TODO: implement props
  List<Object> get props => [
    id,
    saudaBookingTypeId,
    salesOrganizationId,
    distributionChannelId,
    divisionId
  ];
}


class GetTodayCreationStatus extends TodayRateEvent {
  int userId = 0;
  GetTodayCreationStatus({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}



class NotLoggedIn extends TodayRateEvent {}
