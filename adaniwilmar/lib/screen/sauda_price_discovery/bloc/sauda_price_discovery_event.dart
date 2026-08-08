import 'package:adaniwilmar/models/price_discovery_request.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaPriceDiscoveryEvent extends Equatable {
  const SaudaPriceDiscoveryEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaPriceDiscoveryScreen extends SaudaPriceDiscoveryEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  LoadSaudaPriceDiscoveryScreen(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadOverallData extends SaudaPriceDiscoveryEvent {
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

class LoadDealerSaudaDetail extends SaudaPriceDiscoveryEvent {
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

class LoadSalesOrganization extends SaudaPriceDiscoveryEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends SaudaPriceDiscoveryEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends SaudaPriceDiscoveryEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends SaudaPriceDiscoveryEvent {
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

class LoadIncoTerms extends SaudaPriceDiscoveryEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends SaudaPriceDiscoveryEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends SaudaPriceDiscoveryEvent {
  int userId = 0;
  int oilTypeId = 0;
  int currentIndex = -1;
  LoadSKUDetails(
      {required this.userId,
      required this.oilTypeId,
      required this.currentIndex});
  @override
  // TODO: implement props
  List<Object> get props => [userId, oilTypeId];
}

class LoadUserStatistics extends SaudaPriceDiscoveryEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SavePriceDiscovery extends SaudaPriceDiscoveryEvent {
  final PriceDiscoveryRequest request;
  const SavePriceDiscovery({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends SaudaPriceDiscoveryEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class NotLoggedIn extends SaudaPriceDiscoveryEvent {}
