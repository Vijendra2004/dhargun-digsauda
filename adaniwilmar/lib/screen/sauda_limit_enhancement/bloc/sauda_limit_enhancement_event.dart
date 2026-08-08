import 'package:adaniwilmar/models/limit_enhancement_request.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaLimitEnhancementEvent extends Equatable {
  const SaudaLimitEnhancementEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaLimitEnhancementScreen extends SaudaLimitEnhancementEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int bdoId=0;
  LoadSaudaLimitEnhancementScreen(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId,
      this.bdoId=0});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId,bdoId];
}

class LoadOverallData extends SaudaLimitEnhancementEvent {
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

class LoadDealerSaudaDetail extends SaudaLimitEnhancementEvent {
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

class LoadSalesOrganization extends SaudaLimitEnhancementEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends SaudaLimitEnhancementEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends SaudaLimitEnhancementEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadBDO extends SaudaLimitEnhancementEvent {
  int userId = 0;
  bool showAll=false;
  LoadBDO({
    required this.userId,
    this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}

class LoadOilType extends SaudaLimitEnhancementEvent {
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

class LoadIncoTerms extends SaudaLimitEnhancementEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends SaudaLimitEnhancementEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends SaudaLimitEnhancementEvent {
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

class LoadUserStatistics extends SaudaLimitEnhancementEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveLimitEnhancement extends SaudaLimitEnhancementEvent {
  final LimitEnhancementRequest request;
  const SaveLimitEnhancement({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends SaudaLimitEnhancementEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class NotLoggedIn extends SaudaLimitEnhancementEvent {}

class LoadSaudaLimitEnhancementHistoryScreen
    extends SaudaLimitEnhancementEvent {
  int userId = 0;
  int id = 0;
  LoadSaudaLimitEnhancementHistoryScreen({
    required this.userId,
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, id];
}
