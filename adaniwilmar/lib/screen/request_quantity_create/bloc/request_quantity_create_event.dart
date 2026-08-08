import 'package:equatable/equatable.dart';

import '../../../models/Quantity_allocation_create_req.dart';
import '../../../models/request_quantity_create_req.dart';

abstract class RequestQuantityCreateEvent extends Equatable {
  const RequestQuantityCreateEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationCreateUpdateRequest extends RequestQuantityCreateEvent {
  const LoadQuantityAllocationCreateUpdateRequest();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadOverallData extends RequestQuantityCreateEvent {
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

class SaveQuantityRequest extends RequestQuantityCreateEvent {
  RequestQuantityCreateReq requestQuantityCreateReq =
  RequestQuantityCreateReq();

  SaveQuantityRequest({
    required this.requestQuantityCreateReq,
  });

  @override
  // TODO: implement props
  List<Object> get props => [requestQuantityCreateReq];
}

class NotLoggedIn extends RequestQuantityCreateEvent {}

class LoadSalesOrganization extends RequestQuantityCreateEvent {
  LoadSalesOrganization();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDistributionChannel extends RequestQuantityCreateEvent {
  int id = 0;

  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends RequestQuantityCreateEvent {
  int distributionId = 0;

  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class OnLoadOilType extends RequestQuantityCreateEvent {
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

class OnLoadSubCategory extends RequestQuantityCreateEvent {
  const OnLoadSubCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnLoadMaterialDDList extends RequestQuantityCreateEvent {
  String oilTypeId = "0";

  OnLoadMaterialDDList({required this.oilTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypeId];
}

class LoadZonalEmployees extends RequestQuantityCreateEvent {
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

class LoadQAItemFetch extends RequestQuantityCreateEvent {
  int id = 0;

  LoadQAItemFetch({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
