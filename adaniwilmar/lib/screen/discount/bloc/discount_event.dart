
import 'package:equatable/equatable.dart';


import '../../../models/GeoDiscountDetailRequest.dart';
import '../../../models/geography_discount_request.dart';
import '../../../models/user_discount_request.dart';

abstract class CreateDiscountEvent extends Equatable {
const CreateDiscountEvent();

@override
List<Object> get props => [];
}

class LoadUserDiscountList extends CreateDiscountEvent {
  int userId = 0;
  String date;
  LoadUserDiscountList({required this.userId,required this.date});


  @override
  // TODO: implement props
  List<Object> get props => [userId];
}


class LoadAssignedDiscountList extends CreateDiscountEvent {
  int userId = 0;
  String date;
  LoadAssignedDiscountList({required this.userId,required this.date});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadUserDiscountDetails extends CreateDiscountEvent {
  int? id = 0;
  LoadUserDiscountDetails({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id!];
}

class LoadZonalHead extends CreateDiscountEvent {
  int userId = 0;
  bool showAll=false;
  LoadZonalHead({
    required this.userId,this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}

class LoadSalesOrganization extends CreateDiscountEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends CreateDiscountEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends CreateDiscountEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadMaterial extends CreateDiscountEvent {
  int userId = 0;
  LoadMaterial({
    required this.userId
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadMaterialByOilPkgType extends CreateDiscountEvent {
  int oilTypeIds = 0;
  int packGroupIds = 0;
  int oilPkgTypeId = 0;
  LoadMaterialByOilPkgType({
    required this.oilTypeIds,
    required this.packGroupIds,
    required this.oilPkgTypeId
  });
  @override
  // TODO: implement props
  List<Object> get props => [oilTypeIds,packGroupIds, oilPkgTypeId];
}

class LoadOilType extends CreateDiscountEvent {
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

class LoadOilPackageType extends CreateDiscountEvent {

  LoadOilPackageType();

  @override
  List<Object> get props =>
      [];
}

class LoadOilPackageTypeId extends CreateDiscountEvent {

  LoadOilPackageTypeId();

  @override
  List<Object> get props =>
      [];
}

class LoadActiveStates extends CreateDiscountEvent {
  int id = 0;
  LoadActiveStates({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
class LoadNewSaudaScreen extends CreateDiscountEvent {
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

class LoadState extends CreateDiscountEvent {
   List<int> zoneId = [];
  LoadState({
    required this.zoneId
  });
  @override
  // TODO: implement props
  List<Object> get props => [zoneId];
}

class LoadCityTerritory extends CreateDiscountEvent {
   List<int> cityTerritoryId = [];
   LoadCityTerritory({
    required this.cityTerritoryId
  });
  @override
  // TODO: implement props
  List<Object> get props => [cityTerritoryId];
}

class LoadZone extends CreateDiscountEvent {
  int userId = 0;

  LoadZone({
    required this.userId
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class SaveUserDiscount extends CreateDiscountEvent {
  final UserDiscountRequest request;
  final bool isUpdate;
  const SaveUserDiscount({
    required this.request,
    required this.isUpdate
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class SaveAssignedUserDiscount extends CreateDiscountEvent {
  final AssignedDiscountRequest request;
  const SaveAssignedUserDiscount({
    required this.request
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class SaveGeographyDiscount extends CreateDiscountEvent {
  final GeographyDiscountRequest request;
  final bool isUpdate;
  const SaveGeographyDiscount({
    required this.request,
    required this.isUpdate
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class LoadBDO extends CreateDiscountEvent {
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

class LoadDistributor extends CreateDiscountEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;

  LoadDistributor({required this.userId,
    required this.salesOrganizationId,
    required this.distributionChannelId,
    required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];

}

class LoadZonalEmployees extends CreateDiscountEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int stateId = 0;

  LoadZonalEmployees({required this.userId,
    required this.salesOrganizationId,
    required this.distributionChannelId,
    required this.divisonId,
    required this.stateId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId, stateId];

}

class LoadGeographyDiscountList extends CreateDiscountEvent {
  int userId = 0;
  String date;
  LoadGeographyDiscountList({required this.userId,required this.date});


  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class GeoDiscountDetailsRequest extends CreateDiscountEvent {
  GeoDiscountDetailRequest discountRequest;

  GeoDiscountDetailsRequest({
    required this.discountRequest,
  });

  @override
  // TODO: implement props
  List<Object> get props => [discountRequest];
}