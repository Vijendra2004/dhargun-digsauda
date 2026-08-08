import 'package:adaniwilmar/models/deviation_add_request.dart';
import 'package:equatable/equatable.dart';

abstract class NewDeviationRequestEvent extends Equatable {
  const NewDeviationRequestEvent();

  @override
  List<Object> get props => [];
}

class LoadNewDeviationRequestScreen extends NewDeviationRequestEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  LoadNewDeviationRequestScreen(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadOverallData extends NewDeviationRequestEvent {
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

class LoadDealerSaudaDetail extends NewDeviationRequestEvent {
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

class LoadDeviationReason extends NewDeviationRequestEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadDeviationReason({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadApprovedTourPlan extends NewDeviationRequestEvent {
  int id = 0;
  LoadApprovedTourPlan({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadTourPlanDetailList extends NewDeviationRequestEvent {
  int mtpId = 0;
  LoadTourPlanDetailList({
    required this.mtpId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [mtpId];
}

class LoadOilType extends NewDeviationRequestEvent {
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

class LoadIncoTerms extends NewDeviationRequestEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends NewDeviationRequestEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends NewDeviationRequestEvent {
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

class LoadUserStatistics extends NewDeviationRequestEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveDeviation extends NewDeviationRequestEvent {
  final DeviationRequest request;
  const SaveDeviation({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends NewDeviationRequestEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class NotLoggedIn extends NewDeviationRequestEvent {}
