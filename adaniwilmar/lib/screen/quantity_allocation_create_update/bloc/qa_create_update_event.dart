import 'package:equatable/equatable.dart';

import '../../../models/Quantity_allocation_create_req.dart';

abstract class QACreateUpdateEvent extends Equatable {
  const QACreateUpdateEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationCreateUpdateRequest extends QACreateUpdateEvent {
  const LoadQuantityAllocationCreateUpdateRequest();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadOverallData extends QACreateUpdateEvent {
  int userId = 0;
  int oilTypeId = 0;

  LoadOverallData({
    required this.userId,
    required this.oilTypeId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, oilTypeId];
}

class SaveQuantityRequest extends QACreateUpdateEvent {
  QuantityAllocationCreateReq allocationCreateReq =
      QuantityAllocationCreateReq();

  SaveQuantityRequest({
    required this.allocationCreateReq,
  });

  @override
  // TODO: implement props
  List<Object> get props => [allocationCreateReq];
}

class NotLoggedIn extends QACreateUpdateEvent {}

class LoadSalesOrganization extends QACreateUpdateEvent {
  LoadSalesOrganization();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDistributionChannel extends QACreateUpdateEvent {
  int id = 0;

  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends QACreateUpdateEvent {
  int distributionId = 0;

  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class OnLoadOilType extends QACreateUpdateEvent {
  // int salesOrganizationId = 0;
  // int distributionChannelId = 0;
  int divisonId = 0;

  // int userId = 0;
  OnLoadOilType(
      {
      // required this.userId,
      //   required this.salesOrganizationId,
      //   required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [/*userId, salesOrganizationId, distributionChannelId,*/ divisonId];
}

class OnLoadSubCategory extends QACreateUpdateEvent {
  const OnLoadSubCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnLoadMaterialDDList extends QACreateUpdateEvent {
  String oilTypeId = "0";

  OnLoadMaterialDDList({required this.oilTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypeId];
}

class LoadZonalEmployees extends QACreateUpdateEvent {
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;

  LoadZonalEmployees(
      {required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [salesOrganizationId, distributionChannelId, divisonId];
}

class LoadQAItemFetch extends QACreateUpdateEvent {
  int id = 0;

  LoadQAItemFetch({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
