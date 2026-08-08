import 'package:adaniwilmar/models/new_sauda_request.dart';
import 'package:adaniwilmar/models/sales_order_request.dart';
import 'package:equatable/equatable.dart';

abstract class NewSalesOrderEvent extends Equatable {
  const NewSalesOrderEvent();

  @override
  List<Object> get props => [];
}

class LoadNewSalesOrderScreen extends NewSalesOrderEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int bdoId=0;
  LoadNewSalesOrderScreen(
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

class LoadOverallData extends NewSalesOrderEvent {
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

class LoadDealerSalesOrderDetail extends NewSalesOrderEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  int? salesOrganizationId = 0;
  int? distributionChannelId = 0;
  int? divisionId = 0;
  LoadDealerSalesOrderDetail(
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
    salesOrganizationId!,
    distributionChannelId!,
    divisionId!
  ];
}

class LoadDefaults extends NewSalesOrderEvent {
  int id = 0;
  LoadDefaults({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadSalesOrganization extends NewSalesOrderEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends NewSalesOrderEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends NewSalesOrderEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends NewSalesOrderEvent {
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

class LoadShipToParty extends NewSalesOrderEvent {
  int distributorId = 0;
  int salesOrgId=0;
  LoadShipToParty({
    required this.distributorId,required this.salesOrgId
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributorId,salesOrgId];
}

class LoadIncoTerms extends NewSalesOrderEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends NewSalesOrderEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends NewSalesOrderEvent {
  int userId = 0;
  String saudaNumber = "";
  int plantId = 0;
  int dealerId = 0;
  int oilTypeId = 0;
  double vehicleSize=0;
  bool popup = false;
  LoadSKUDetails(
      {required this.userId,
        required this.saudaNumber,
        required this.plantId,
        required this.dealerId,
        required this.oilTypeId,
        required this.vehicleSize,
        this.popup = false});
  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, saudaNumber, plantId, dealerId, oilTypeId,vehicleSize, popup];
}

class LoadFillerSKUDetails extends NewSalesOrderEvent {
  int userId = 0;
  double volumePercentage = 0;
  int plantId = 0;
  int dealerId = 0;
  double weightPercentage = 0;
  double vehicleSize = 0;
  LoadFillerSKUDetails(
      {required this.userId,
        required this.volumePercentage,
        required this.plantId,
        required this.dealerId,
        required this.vehicleSize,
        required this.weightPercentage});
  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, volumePercentage, plantId, dealerId, vehicleSize, weightPercentage];
}

class LoadUserStatistics extends NewSalesOrderEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveSalesOrder extends NewSalesOrderEvent {
  final SalesOrder request;
  SaveSalesOrder({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends NewSalesOrderEvent {
  final bool popup;
  ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class LoadBDO extends NewSalesOrderEvent {
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
class LoadContractDetail extends NewSalesOrderEvent {
  int distributorId = 0;
  int salesOrgId=0;
  int skuId=0;
  LoadContractDetail({
    required this.distributorId,required this.salesOrgId,required this.skuId
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributorId,salesOrgId,skuId];
}

class NotLoggedIn extends NewSalesOrderEvent {}
