import 'package:adaniwilmar/models/EssentialSkuMapping.dart';
import 'package:adaniwilmar/models/new_sauda_request.dart';
import 'package:equatable/equatable.dart';

import '../../../models/qps_req_model.dart';

abstract class NewSaudaEvent extends Equatable {
  const NewSaudaEvent();

  @override
  List<Object> get props => [];
}

class LoadNewSaudaScreen extends NewSaudaEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int bdoId=0;
  LoadNewSaudaScreen(
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


class OnLoadSaudaRestriction extends NewSaudaEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int dealerId = 0;
  int stateTraderId = 0;
  int skuId = 0;

  OnLoadSaudaRestriction(
      {required this.userId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisonId,
        required this.dealerId,
        required this.stateTraderId,
        required this.skuId,
      }
  );

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId,dealerId,stateTraderId,skuId ];
}


class LoadOverallData extends NewSaudaEvent {
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

class LoadDealerSaudaDetail extends NewSaudaEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
  bool loadLimit=false;
  LoadDealerSaudaDetail(
      {required this.id,
      required this.saudaBookingTypeId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisionId,
      this.loadLimit=false});

  @override
  // TODO: implement props
  List<Object> get props => [
        id,
        saudaBookingTypeId,
        salesOrganizationId,
        distributionChannelId,
        divisionId,
        loadLimit
      ];
}

class LoadDefaults extends NewSaudaEvent {
  int id = 0;
  LoadDefaults({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadSalesOrganization extends NewSaudaEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends NewSaudaEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends NewSaudaEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends NewSaudaEvent {
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

class MandatorySkus extends NewSaudaEvent {
  int salesOrganizationId = 0;
  List<Sku> skusId = [];
  int stateId = 0;
  int dealerId = 0;
  int oilTypeId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int userId = 0;
  int plantId = 0;
  MandatorySkus(
      {required this.userId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisonId,
      required this.stateId,
      required this.dealerId,
      required this.oilTypeId,
        required this.plantId,
      required this.skusId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId,stateId,dealerId,oilTypeId,skusId,plantId];
}

class LoadIncoTerms extends NewSaudaEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends NewSaudaEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends NewSaudaEvent {
  int userId = 0;
  int saudaBookingTypeId = 0;
  int plantId = 0;
  int dealerId = 0;
  int oilTypeId = 0;
  int skuId=0;
  bool popup = false;
  LoadSKUDetails(
      {required this.userId,
      required this.saudaBookingTypeId,
      required this.plantId,
      required this.dealerId,
      required this.oilTypeId,
      this.popup = false,
      this.skuId=0});
  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, saudaBookingTypeId, plantId, dealerId, oilTypeId, popup,skuId];
}

class LoadUserStatistics extends NewSaudaEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveSauda extends NewSaudaEvent {
  final NewSaudaRequest request;
  const SaveSauda({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends NewSaudaEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class LoadBDO extends NewSaudaEvent {
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

class NotLoggedIn extends NewSaudaEvent {}

class OnLoadQPS extends NewSaudaEvent {
  List<SkuDetails> qpsReqModel = <SkuDetails>[];
  bool isFromAlert = false;
  bool isAlertTriggered = false;
  int dealerId = 0;
  OnLoadQPS({
    required this.qpsReqModel,
     this.isFromAlert = false,  this. isAlertTriggered = false,  this.dealerId = 0

  });
  @override
  // TODO: implement props
  List<Object> get props => [qpsReqModel,isFromAlert,isAlertTriggered,dealerId];
}


class OnLoadQPSDiscountList extends NewSaudaEvent {
  List<SkuDetails> qpsReqModel = <SkuDetails>[];
  int dealerId = 0;

  OnLoadQPSDiscountList({
    required this.qpsReqModel,
     this.dealerId = 0
  });
  @override
  // TODO: implement props
  List<Object> get props => [qpsReqModel, dealerId];
}

