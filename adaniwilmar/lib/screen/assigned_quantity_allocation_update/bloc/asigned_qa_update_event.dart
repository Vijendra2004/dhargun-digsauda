import 'package:equatable/equatable.dart';

import '../../../models/Quantity_allocation_create_req.dart';

abstract class AssignedQAUpdateEvent extends Equatable {
  const AssignedQAUpdateEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationCreateUpdateRequest extends AssignedQAUpdateEvent {
  const LoadQuantityAllocationCreateUpdateRequest();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadOverallData extends AssignedQAUpdateEvent {
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

class SaveQuantityRequest extends AssignedQAUpdateEvent {
  QuantityAllocationCreateReq allocationCreateReq =
      QuantityAllocationCreateReq();

  SaveQuantityRequest({
    required this.allocationCreateReq,
  });

  @override
  // TODO: implement props
  List<Object> get props => [allocationCreateReq];
}

class NotLoggedIn extends AssignedQAUpdateEvent {}

class LoadSalesOrganization extends AssignedQAUpdateEvent {
  LoadSalesOrganization();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDistributionChannel extends AssignedQAUpdateEvent {
  int id = 0;

  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends AssignedQAUpdateEvent {
  int distributionId = 0;

  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class OnLoadOilType extends AssignedQAUpdateEvent {
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

class OnLoadSubCategory extends AssignedQAUpdateEvent {
  const OnLoadSubCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnLoadMaterialDDList extends AssignedQAUpdateEvent {
  String oilTypeId = "0";

  OnLoadMaterialDDList({required this.oilTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypeId];
}

class LoadZonalEmployees extends AssignedQAUpdateEvent {
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

class LoadQAItemFetch extends AssignedQAUpdateEvent {
  int id = 0;

  LoadQAItemFetch({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
