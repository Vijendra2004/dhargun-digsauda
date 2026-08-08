import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/models/GeoGraphyDetailResponseModel.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/geography_discount_request.dart';
import 'package:adaniwilmar/models/oil_package_type_id.dart';
import 'package:adaniwilmar/models/oil_package_types.dart'as cat;
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/screen/discount/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/bdo_list_response.dart';
import '../../../models/geography_discount_list.dart';
import '../../../models/pack_group_list.dart';
import '../../../models/state_response.dart';
import '../../../models/zone_response.dart';
import '../../../models/zone_state_cities_response.dart';
import '../../../models/assigned_discount_list.dart';
import '../../../models/bdo_list_response.dart';
import '../../../models/dealer_response.dart';
import '../../../models/pack_group_list.dart';
import '../../../models/user_discount_list.dart';

import '../../../repo/service_repository.dart';
import '../../../utils/constant.dart';
import 'discount_event.dart';
import 'discount_state.dart';

class CreateDiscountBloc
    extends Bloc<CreateDiscountEvent, CreateDiscountState> {
  CreateDiscountBloc() : super(InitialCreateDiscountState()) {
    on<LoadState>((event, emit) => _getStateIdList(event, emit));
    on<LoadCityTerritory>((event, emit) => _getCityTerritoryList(event, emit));
    on<LoadZone>((event, emit) => _getZoneList(event, emit));
    on<LoadSalesOrganization>((event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>((event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadUserDiscountList>(
        (event, emit) => _getUserDiscountList(event, emit));
    on<LoadUserDiscountDetails>(
        (event, emit) => _getUserDiscountDetails(event, emit));
    on<LoadZonalHead>((event, emit) => _getZonalHeadList(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeURL(event, emit));
    on<LoadOilPackageType>((event, emit) => _getOilPackageURL(event, emit));
    on<LoadOilPackageTypeId>((event, emit) => _getOilPackageTypeIdURL(event, emit));
    on<LoadMaterial>((event, emit) => _getMaterialList(event, emit));
    on<LoadMaterialByOilPkgType>((event, emit) => _getMaterialByOilTypePackageTypeList(event, emit));
    on<SaveUserDiscount>((event, emit) => _saveUserDiscount(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadDistributor>((event, emit) => _getDistributorList(event, emit));
    on<LoadZonalEmployees>((event, emit) => _getZonalEmployeesList(event, emit));
    on<LoadActiveStates>((event, emit) => _getStates(event, emit));

    on<GeoDiscountDetailsRequest>((event, emit) => getGeoDiscountDetail(event, emit));
    on<LoadNewSaudaScreen>((event, emit) => _getDistributorSaudaList(event, emit));
    on<LoadAssignedDiscountList>(
        (event, emit) => _getAssignedDiscountList(event, emit));
    on<SaveAssignedUserDiscount>(
        (event, emit) => _updateUserDiscount(event, emit));

    on<LoadGeographyDiscountList>(
        (event, emit) => _getGeographyDiscountList(event, emit));
    on<SaveGeographyDiscount>((event, emit) => _saveGeographyDiscount(event, emit));
  }

  CreateDiscountState get initialState => InitialCreateDiscountState();

  Future<void> _getDistributorSaudaList(LoadNewSaudaScreen event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
      await ServiceRepository().getDealerByUserIdList(Constants.AUTH_USERID, event.salesOrganizationId, event.distributionChannelId, event.divisonId, bdoIds: event.bdoId > 0 ? [event.bdoId] : []);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => distList.add(DistributorList.fromJson(f)));
        // }
        // if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(distributorList: distList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getUserDiscountList(
      LoadUserDiscountList event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta userDiscount = await ServiceRepository()
          .getUserDiscountList(Constants.AUTH_USERID, event.date);
      GMLogger.v("userDiscount" + userDiscount.statusMsg);
      GMLogger.v("userDiscount" + userDiscount.statusCode.toString());
      List<UserDiscountListRequest> userDiscountList = [];
      if ((userDiscount.statusCode == 200)) {
        jsonDecode(userDiscount.statusMsg)['response'].forEach(
            (f) => userDiscountList.add(UserDiscountListRequest.fromJson(f)));
      }
      if ((userDiscount.statusCode == 200)) {
        emit(HideProgressBar());
        emit(UserDiscountListRequestSuccess(
            userDiscountRequestList: userDiscountList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: userDiscount.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getSalesOrganization(LoadSalesOrganization event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSalesOrganization(salesOrganization: salesOrgList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getOilTypeURL(LoadOilType event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository()
          .getOilTypeList(Constants.AUTH_USERID, salesOrgId: event.salesOrganizationId, distriChannelId: event.distributionChannelId, divisionId: event.divisonId, isFromSauda: true);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<OilType> oilTypes = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => oilTypes.add(OilType.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilType(oilTypeList: oilTypes));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }


  Future<void> _getOilPackageURL(LoadOilPackageType event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta oilPackType = await ServiceRepository().getOilPackingType();
      GMLogger.v("Sales" + oilPackType.statusMsg);
      GMLogger.v("Sales" + oilPackType.statusCode.toString());
      List<cat.Category> oilPackageType = [];
      if (oilPackType.statusCode == 200) {
        jsonDecode(oilPackType.statusMsg)['response'].forEach((f) => oilPackageType.add(cat.Category.fromJson(f)));
      }

      if (oilPackType.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilPackage(oilPackageTypeList: oilPackageType));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: oilPackType.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }


  Future<void> _getOilPackageTypeIdURL(LoadOilPackageTypeId event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta oilPackType = await ServiceRepository().getOilPackingTypeId();
      GMLogger.v("Sales" + oilPackType.statusMsg);
      GMLogger.v("Sales" + oilPackType.statusCode.toString());
      List<OilPackGroupTypeId> oilPackageType = [];
      if (oilPackType.statusCode == 200) {
        jsonDecode(oilPackType.statusMsg)['response'].forEach((f) => oilPackageType.add(OilPackGroupTypeId.fromJson(f)));
      }

      if (oilPackType.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilPackageTypeId(oilPackageTypeId: oilPackageType));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: oilPackType.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributionChannelData(LoadDistributionChannel event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getDistributionChannel(event.id);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<DistributionChannel> distrChannels = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => distrChannels.add(DistributionChannel.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDistributionChannel(distributionChannel: distrChannels));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getVerticalData(LoadVerticalList event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getVertical(event.distributionId);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<Vertical> verticals = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => verticals.add(Vertical.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadVerticalList(verticalList: verticals));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }


  Future<void> _getUserDiscountDetails(
      LoadUserDiscountDetails event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta userDiscount =
          await ServiceRepository().getUserDiscountDetails(event.id!);
      GMLogger.v("userDiscountDetails" + userDiscount.statusMsg);
      GMLogger.v("userDiscountDetails" + userDiscount.statusCode.toString());
      List<UserDiscountDetails> userDiscountDetails = [];
      if (userDiscount.statusCode == 200) {
        jsonDecode(userDiscount.statusMsg)['response'].forEach(
            (f) => userDiscountDetails.add(UserDiscountDetails.fromJson(f)));
      }
      if (userDiscount.statusCode == 200) {
        emit(HideProgressBar());
        emit(UserDiscountDetailsRequestSuccess(
            userDiscountDetailsList: userDiscountDetails));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: userDiscount.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getZonalHeadList(
      LoadZonalHead event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getZonalHeadList(event.userId);
      List<BdoList> zonalHeadList = [];
      if (event.showAll) {
        BdoList defaultDist = BdoList();
        defaultDist.id = 0;
        defaultDist.name = "All Zonal Traders";
        zonalHeadList.add(defaultDist);
      }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => zonalHeadList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadZonalHead(zonalHeadList: zonalHeadList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getMaterialList(
      LoadMaterial event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getMaterialList(event.userId);
      List<BdoList> materialList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => materialList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadMaterial(metrialList: materialList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getMaterialByOilTypePackageTypeList(
      LoadMaterialByOilPkgType event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
      await ServiceRepository().getMaterialByOilTypePackageTypeList(event.oilTypeIds,event.packGroupIds, event.oilPkgTypeId);
      List<BdoList> materialList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => materialList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadMaterial(metrialList: materialList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getZoneList(
      LoadZone event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getActiveZoneList(event.userId);
      List<ActiveZone> zoneList = [];
      if (metaDealerList.statusCode == 200) {
        // print(metaDealerList.toJson());
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => zoneList.add(ActiveZone.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadZone(zoneList: zoneList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveUserDiscount(
      SaveUserDiscount event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda;
      if (!event.isUpdate) {
        savedSauda = await ServiceRepository().saveUserDiscount(event.request);
      } else {
        savedSauda =
            await ServiceRepository().updateUserDiscount(event.request);
      }

      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if ((savedSauda.statusCode == 200)) {
        emit(HideProgressBar());
        emit(OnSaveUserDiscount(id: savedSauda.statusMsg));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getStateIdList(
      LoadState event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getStateIDList(event.zoneId);
      List<ActiveStateResponse> stateList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => stateList.add(ActiveStateResponse.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadState(stateList: stateList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getCityTerritoryList(
      LoadCityTerritory event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getCityTerritoryList(event.cityTerritoryId);
      List<CityTerritory> cityTerritoryList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => cityTerritoryList.add(CityTerritory.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnCityTerritory(cityTerritoryList:  cityTerritoryList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getStates(
      LoadActiveStates event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta states = await ServiceRepository().getActiveStateList();
      List<ActiveState> stateList = [];
      if (states.statusCode == 200) {
        jsonDecode(states.statusMsg)['response']
            .forEach((f) => stateList.add(ActiveState.fromJson(f)));
      }
      GMLogger.v("States" + states.statusMsg);
      if (states.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadStates(states: stateList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: states.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

//Assigned discount

  Future<void> _getAssignedDiscountList(
      LoadAssignedDiscountList event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta assignedDiscount = await ServiceRepository()
          .getAssignedDiscountList(Constants.AUTH_USERID, event.date);
      GMLogger.v("assignedDiscount" + assignedDiscount.statusMsg);
      GMLogger.v("assignedDiscount" + assignedDiscount.statusCode.toString());
      List<AssignedDiscountListRequest> assignedDiscountList = [];
      if (assignedDiscount.statusCode == 200) {
        jsonDecode(assignedDiscount.statusMsg)['response'].forEach((f) =>
            assignedDiscountList.add(AssignedDiscountListRequest.fromJson(f)));
      }
      if (assignedDiscount.statusCode == 200) {
        emit(HideProgressBar());
        emit(AssignedDiscountListRequestSuccess(
            assignedDiscountRequestList: assignedDiscountList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: assignedDiscount.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getBdoList(
      LoadBDO event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      List<BdoList> bdoList = [];
      if (event.showAll) {
        BdoList bdo = BdoList();
        bdo.id = 0;
        bdo.name = "All State Traders";
        bdoList.add(bdo);
      }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadBDO(bdoList: bdoList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributorList(
      LoadDistributor event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerByUserIdList(
          Constants.AUTH_USERID,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisonId);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDistributor(distributorList: distList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getZonalEmployeesList(
      LoadZonalEmployees event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaZonalEmpList = await ServiceRepository().getZonalEmployeesList(

        Constants.AUTH_USERID,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisonId,
        stateId:event.stateId
          );
      List<ZonalEmployeeList> zEmpList = [];
      if (metaZonalEmpList.statusCode == 200) {
        jsonDecode(metaZonalEmpList.statusMsg)['response']
            .forEach((f) => zEmpList.add(ZonalEmployeeList.fromJson(f)));
      }
      if (metaZonalEmpList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadZonalEmployees(zoanlEmpList: zEmpList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaZonalEmpList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _updateUserDiscount(
      SaveAssignedUserDiscount event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda;
      savedSauda =
          await ServiceRepository().saveAssignedUserDiscount(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if ((savedSauda.statusCode == 200)) {
        emit(HideProgressBar());
        emit(OnSaveUserDiscount(id: savedSauda.statusMsg));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }


  //Geography discount

  Future<void> _getGeographyDiscountList(
      LoadGeographyDiscountList event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta userDiscount = await ServiceRepository()
          .getGeoDiscountList(Constants.AUTH_USERID, event.date);
      GMLogger.v("geographyDiscountMessage" + userDiscount.statusMsg);
      GMLogger.v("geographyDiscountStatus" + userDiscount.statusCode.toString());
      List<GeographyDiscountList> geographyDiscountList = [];
      if ((userDiscount.statusCode == 200)) {
        jsonDecode(userDiscount.statusMsg)['response']['data'].forEach(
                (f) => geographyDiscountList.add(GeographyDiscountList.fromJson(f)));
      }
      if ((userDiscount.statusCode == 200)) {
        emit(HideProgressBar());
        emit(GeographyDiscountRequestSuccess(
            geographyDiscountList: geographyDiscountList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: userDiscount.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveGeographyDiscount(
      SaveGeographyDiscount event, Emitter<CreateDiscountState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedGeography;
      if(!event.isUpdate){
        savedGeography = await ServiceRepository().saveGeographyDiscount(event.request);
      }
      else{
        savedGeography = await ServiceRepository().updateUserGeographyDiscount(event.request);
      }
      GMLogger.v(savedGeography.statusCode.toString());
      GMLogger.v(savedGeography.statusMsg);
      if ((savedGeography.statusCode == 200)) {
        emit(HideProgressBar());
        emit(OnSaveUserDiscount(id: savedGeography.statusMsg));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedGeography.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> getGeoDiscountDetail(
      GeoDiscountDetailsRequest event, Emitter<CreateDiscountState> emit) async {

    try {
      emit(ShowProgressBar());
      Meta? geoGraphyDetailResponse;
      geoGraphyDetailResponse = await ServiceRepository().getGeographyDiscountDetailsApi(event.discountRequest);
      GeoGraphyDetailResponseModel? responseModel;
      if ((geoGraphyDetailResponse.statusCode == 200)) {
        responseModel = GeoGraphyDetailResponseModel.fromJson(jsonDecode(geoGraphyDetailResponse.statusMsg)['response']);
      }
      if ((geoGraphyDetailResponse.statusCode == 200)) {
        emit(HideProgressBar());
        emit(GeographyDetailSuccess(geoDiscountDetail: responseModel));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: geoGraphyDetailResponse.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }



}
