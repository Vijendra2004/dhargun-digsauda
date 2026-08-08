import 'package:equatable/equatable.dart';

import '../../../models/Quantity_allocation_create_req.dart';
import '../../../models/oiltype_response.dart';

abstract class RequestedQAListEvent extends Equatable {
  const RequestedQAListEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationCreateUpdateRequest extends RequestedQAListEvent {


  const LoadQuantityAllocationCreateUpdateRequest();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadOverallData extends RequestedQAListEvent {
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

class SaveQuantityRequest extends RequestedQAListEvent {
  QuantityAllocationCreateReq allocationCreateReq = QuantityAllocationCreateReq();

  SaveQuantityRequest({
    required this.allocationCreateReq,
  });

  @override
  // TODO: implement props
  List<Object> get props => [allocationCreateReq];
}

class NotLoggedIn extends RequestedQAListEvent {}



class LoadSalesOrganization extends RequestedQAListEvent {
  LoadSalesOrganization();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDistributionChannel extends RequestedQAListEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends RequestedQAListEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}


class OnLoadOilType extends RequestedQAListEvent {
  // int salesOrganizationId = 0;
  // int distributionChannelId = 0;
  int divisonId = 0;
  // int userId = 0;
  OnLoadOilType({
  // required this.userId,
      //   required this.salesOrganizationId,
      //   required this.distributionChannelId,
        required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [/*userId, salesOrganizationId, distributionChannelId,*/ divisonId];
}

class OnLoadSubCategory extends RequestedQAListEvent {

  const OnLoadSubCategory();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnLoadMaterialDDList extends RequestedQAListEvent {
  String oilTypeId = "0";

 OnLoadMaterialDDList({required this.oilTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypeId];
}

class LoadZonalEmployees extends RequestedQAListEvent {
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;

  LoadZonalEmployees({
    required this.salesOrganizationId,
    required this.distributionChannelId,
    required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [ salesOrganizationId, distributionChannelId, divisonId ];

}
