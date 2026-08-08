

import 'package:adaniwilmar/models/oil_package_type_id.dart';
import 'package:adaniwilmar/models/oil_package_types.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/GeoGraphyDetailResponseModel.dart';
import '../../../models/bdo_list_response.dart';
import '../../../models/daily_rate_response.dart';
import '../../../models/default_input_response.dart';
import '../../../models/geography_discount_list.dart';
import '../../../models/pack_group_list.dart';
import '../../../models/state_response.dart';
import '../../../models/zone_response.dart';
import '../../../models/zone_state_cities_response.dart';


import 'package:equatable/equatable.dart';

import '../../../models/assigned_discount_list.dart';
import '../../../models/bdo_list_response.dart';
import '../../../models/daily_rate_response.dart';
import '../../../models/dealer_response.dart';
import '../../../models/default_input_response.dart';
import '../../../models/pack_group_list.dart';
import '../../../models/user_discount_list.dart';


abstract class CreateDiscountState extends Equatable {
  const CreateDiscountState();
  @override
  List<Object> get props => [];
}

class InitialCreateDiscountState extends CreateDiscountState {}

class ShowProgressBar extends CreateDiscountState {}

class HideProgressBar extends CreateDiscountState {}

class OnLoadZonalHead extends CreateDiscountState {
  final List<BdoList> zonalHeadList;
  const OnLoadZonalHead({required this.zonalHeadList});

  @override
  // TODO: implement props
  List<Object> get props => [zonalHeadList];
}

class OnLoadSuccess extends CreateDiscountState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadMaterial extends CreateDiscountState {
  final List<BdoList> metrialList;
  const OnLoadMaterial({required this.metrialList});

  @override
  // TODO: implement props
  List<Object> get props => [metrialList];
}

class OnLoadStates extends CreateDiscountState {
  final List<ActiveState> states;
  const OnLoadStates({required this.states});

  @override
  // TODO: implement props
  List<Object> get props => [states];
}


class OnLoadZone extends CreateDiscountState {
  final List<ActiveZone> zoneList;
  const OnLoadZone({required this.zoneList});

  @override
  // TODO: implement props
  List<Object> get props => [zoneList];
}

class OnLoadSalesOrganization extends CreateDiscountState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadOilType extends CreateDiscountState {
  final List<OilType> oilTypeList;
  const OnLoadOilType({ required this.oilTypeList});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypeList];
}

class OnLoadOilPackage extends CreateDiscountState {
  final List<Category> oilPackageTypeList;
  const OnLoadOilPackage({ required this.oilPackageTypeList});

  @override
  // TODO: implement props
  List<Object> get props => [oilPackageTypeList];
}

class OnLoadOilPackageTypeId extends CreateDiscountState {
  final List<OilPackGroupTypeId> oilPackageTypeId;
  const OnLoadOilPackageTypeId({ required this.oilPackageTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [oilPackageTypeId];
}



class OnLoadDistributionChannel extends CreateDiscountState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends CreateDiscountState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadState extends CreateDiscountState {
  final List<ActiveStateResponse> stateList;
  const OnLoadState({required this.stateList});

  @override
  // TODO: implement props
  List<Object> get props => [stateList];
}

class OnCityTerritory extends CreateDiscountState {
  final List<CityTerritory> cityTerritoryList;
  const OnCityTerritory({required this.cityTerritoryList});

  @override
  // TODO: implement props
  List<Object> get props => [cityTerritoryList];
}


class OnFailure extends CreateDiscountState {
  final String error;

  const OnFailure({required this.error});


  @override
  // TODO: implement props
  List<Object> get props => [error];
}


class OnSaveUserDiscount extends CreateDiscountState {
  final String id;
  const OnSaveUserDiscount({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class UserDiscountListRequestSuccess extends CreateDiscountState {
  final List<UserDiscountListRequest> userDiscountRequestList;
  const UserDiscountListRequestSuccess({required this.userDiscountRequestList});

  @override
  // TODO: implement props
  List<Object> get props => [userDiscountRequestList];
}

class AssignedDiscountListRequestSuccess extends CreateDiscountState {
  final List<AssignedDiscountListRequest> assignedDiscountRequestList;
  const AssignedDiscountListRequestSuccess({required this.assignedDiscountRequestList});

  @override
  // TODO: implement props
  List<Object> get props => [assignedDiscountRequestList];
}

class UserDiscountDetailsRequestSuccess extends CreateDiscountState {
  final List<UserDiscountDetails> userDiscountDetailsList;
  const UserDiscountDetailsRequestSuccess({required this.userDiscountDetailsList});

  @override
  // TODO: implement props
  List<Object> get props => [userDiscountDetailsList];
}

class OnLoadBDO extends CreateDiscountState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}

class OnLoadDistributor extends CreateDiscountState {
  final List<DistributorList> distributorList;

  const OnLoadDistributor({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadZonalEmployees extends CreateDiscountState {
  final List<ZonalEmployeeList> zoanlEmpList;

  const OnLoadZonalEmployees({required this.zoanlEmpList});

  @override
  // TODO: implement props
  List<Object> get props => [zoanlEmpList];
}

class GeographyDiscountRequestSuccess extends CreateDiscountState {
  final List<GeographyDiscountList> geographyDiscountList;

  const GeographyDiscountRequestSuccess({required this.geographyDiscountList});

  @override
  // TODO: implement props
  List<Object> get props => [geographyDiscountList];

}


class GeographyDetailSuccess extends CreateDiscountState {
  GeoGraphyDetailResponseModel? geoDiscountDetail;

  GeographyDetailSuccess({required this.geoDiscountDetail});

  @override
  // TODO: implement props
  List<Object> get props => [geoDiscountDetail!];

}


