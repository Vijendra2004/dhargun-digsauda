import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:equatable/equatable.dart';

abstract class NewSpecialRateEvent extends Equatable {
  const NewSpecialRateEvent();

  @override
  List<Object> get props => [];
}

class LoadNewSpecialRateScreen extends NewSpecialRateEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  LoadNewSpecialRateScreen(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadOverallData extends NewSpecialRateEvent {
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

class LoadDealerSaudaDetail extends NewSpecialRateEvent {
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

class LoadSalesOrganization extends NewSpecialRateEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends NewSpecialRateEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends NewSpecialRateEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends NewSpecialRateEvent {
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

class LoadIncoTerms extends NewSpecialRateEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends NewSpecialRateEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends NewSpecialRateEvent {
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

class LoadUserStatistics extends NewSpecialRateEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveSpecialRate extends NewSpecialRateEvent {
  final SpecialRateRequest request;
  const SaveSpecialRate({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends NewSpecialRateEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class NotLoggedIn extends NewSpecialRateEvent {}
