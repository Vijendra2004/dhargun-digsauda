import 'package:equatable/equatable.dart';
import '../../../models/request_quantity_create_req.dart';
import '../../../models/request_quantity_status_update_req.dart';

abstract class RequestedQuantityApproveEvent extends Equatable {
  const RequestedQuantityApproveEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationCreateUpdateRequest extends RequestedQuantityApproveEvent {
  const LoadQuantityAllocationCreateUpdateRequest();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadOverallData extends RequestedQuantityApproveEvent {
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

class SaveQuantityRequest extends RequestedQuantityApproveEvent {
  RequestQuantityStatusUpdateReq requestQuantityStatusUpdateReq =
  RequestQuantityStatusUpdateReq();

  SaveQuantityRequest({
    required this.requestQuantityStatusUpdateReq,
  });

  @override
  // TODO: implement props
  List<Object> get props => [requestQuantityStatusUpdateReq];
}

class NotLoggedIn extends RequestedQuantityApproveEvent {}

class LoadSalesOrganization extends RequestedQuantityApproveEvent {
  LoadSalesOrganization();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDistributionChannel extends RequestedQuantityApproveEvent {
  int id = 0;

  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends RequestedQuantityApproveEvent {
  int distributionId = 0;

  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class OnLoadOilType extends RequestedQuantityApproveEvent {
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

class OnLoadSubCategory extends RequestedQuantityApproveEvent {
  const OnLoadSubCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnLoadMaterialDDList extends RequestedQuantityApproveEvent {
  String oilTypeId = "0";

  OnLoadMaterialDDList({required this.oilTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypeId];
}

class LoadZonalEmployees extends RequestedQuantityApproveEvent {
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

class LoadQAItemFetch extends RequestedQuantityApproveEvent {
  int id = 0;

  LoadQAItemFetch({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
