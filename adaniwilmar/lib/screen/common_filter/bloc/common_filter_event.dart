import 'package:equatable/equatable.dart';

abstract class CommonFilterEvent extends Equatable {
  const CommonFilterEvent();

  @override
  List<Object> get props => [];
}

class LoadCommonFilterScreen extends CommonFilterEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  LoadCommonFilterScreen(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadOverallData extends CommonFilterEvent {
  int userId = 0;
  int oilTypeId = 0;
  int plantId = 0;
  int verticalId = 0;
  int incoTermId = 0;
  LoadOverallData(
      {required this.userId,
      required this.oilTypeId,
      required this.plantId,
      required this.verticalId,
      required this.incoTermId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, oilTypeId, plantId, verticalId, incoTermId];
}

class LoadDealerSaudaDetail extends CommonFilterEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
  LoadDealerSaudaDetail(
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

class LoadSalesOrganization extends CommonFilterEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends CommonFilterEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends CommonFilterEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends CommonFilterEvent {
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

class LoadIncoTerms extends CommonFilterEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends CommonFilterEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadBDO extends CommonFilterEvent {
  int userId = 0;
  LoadBDO({
    required this.userId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadPackGroupList extends CommonFilterEvent {
  int userId = 0;
  LoadPackGroupList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadStates extends CommonFilterEvent {
  int id = 0;
  LoadStates({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadSKUDetails extends CommonFilterEvent {
  int userId = 0;
  int saudaBookingTypeId = 0;
  int plantId = 0;
  int dealerId = 0;
  int oilTypeId = 0;
  bool popup = false;
  LoadSKUDetails(
      {required this.userId,
      required this.saudaBookingTypeId,
      required this.plantId,
      required this.dealerId,
      required this.oilTypeId,
      this.popup = false});
  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, saudaBookingTypeId, plantId, dealerId, oilTypeId, popup];
}

class LoadUserStatistics extends CommonFilterEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}
