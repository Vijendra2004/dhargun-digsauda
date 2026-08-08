import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/pack_group_list.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
// import 'package:adaniwilmar/models/sku_pricing_response.dart';
// import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/common_filter/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class CommonFilterBloc extends Bloc<CommonFilterEvent, CommonFilterState> {
  CommonFilterBloc() : super(InitialCommonFilterState()) {
    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDealerSaudaDetail>(
        (event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadIncoTerms>((event, emit) => _getIncoTermsData(event, emit));
    on<LoadPlant>((event, emit) => _getPlantData(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadCommonFilterScreen>(
        (event, emit) => _getDistributorList(event, emit));
    on<LoadSKUDetails>((event, emit) => _getSKUData(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadPackGroupList>((event, emit) => _getPackGroupData(event, emit));
  }
  CommonFilterState get initialState => InitialCommonFilterState();

  Future<void> _getDistributorList(
      LoadCommonFilterScreen event, Emitter<CommonFilterState> emit) async {
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

  Future<void> _getBdoList(
      LoadBDO event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      List<BdoList> bdoList = [];
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

  Future<void> _getSalesOrganization(
      LoadSalesOrganization event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository()
          .getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
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

  Future<void> _getDistributorData(
      LoadDealerSaudaDetail event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta dealerSaudaDetails = await ServiceRepository().getDealerSaudaDetails(
          event.id,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisionId);
      DealerSaudaDetail saudaDetail = DealerSaudaDetail();
      if (dealerSaudaDetails.statusCode == 200) {
        GMLogger.v(dealerSaudaDetails.statusMsg);
        saudaDetail = DealerSaudaDetail.fromJson(
            jsonDecode(dealerSaudaDetails.statusMsg)['response']);
      }

      if (dealerSaudaDetails.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSaudaDetail(
            dealerSaudaDetail: saudaDetail, skuDetail: const []));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: dealerSaudaDetails.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getSKUData(
      LoadSKUDetails event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList = await ServiceRepository()
          .getWholesalerVisitSecondarySales(event.oilTypeId);
      List<OilTypeSkuList> skuList = [];
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response']
            .forEach((f) => skuList.add(OilTypeSkuList.fromJson(f)));
      }

      if (metaSkuList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSKUDetails(skuList: skuList, isPopup: event.popup));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSkuList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributionChannelData(
      LoadDistributionChannel event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getDistributionChannel(event.id);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<DistributionChannel> distrChannels = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => distrChannels.add(DistributionChannel.fromJson(f)));
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

  Future<void> _getVerticalData(
      LoadVerticalList event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getVertical(event.distributionId);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<Vertical> verticals = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => verticals.add(Vertical.fromJson(f)));
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

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeList(
          Constants.AUTH_USERID,
          salesOrgId: event.salesOrganizationId,
          distriChannelId: event.distributionChannelId,
          divisionId: event.divisonId);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<OilType> oilTypes = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => oilTypes.add(OilType.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilType(oilTypes: oilTypes));
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

  Future<void> _getIncoTermsData(
      LoadIncoTerms event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getIncoTermsList();
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<IncoTerms> incoTerms = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => incoTerms.add(IncoTerms.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadIncoTerms(incoTerms: incoTerms));
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

  Future<void> _getPlantData(
      LoadPlant event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getPlantList();
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<PlanDepotList> plants = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => plants.add(PlanDepotList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPlant(plantList: plants));
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

  Future<void> _getPackGroupData(
      LoadPackGroupList event, Emitter<CommonFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getPackGroupList(Constants.AUTH_USERID);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<PackGroupList> packGroups = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => packGroups.add(PackGroupList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPackGroup(packGroups: packGroups));
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

  // Future<void> _getStates(
  //     LoadStates event, Emitter<CommonFilterState> emit) async {
  //   try {
  //     emit(ShowProgressBar());
  //     Meta states = await ServiceRepository().getActiveStateList();
  //     GMLogger.v("States" + states.statusMsg);
  //     GMLogger.v("Sales" + states.statusCode.toString());
  //     List<ActiveState> stateList = [];
  //     if (states.statusCode == 200) {
  //       jsonDecode(states.statusMsg)['response']
  //           .forEach((f) => stateList.add(ActiveState.fromJson(f)));
  //     }
  //
  //     if (states.statusCode == 200) {
  //       emit(HideProgressBar());
  //       emit(OnLoadStates(states: stateList));
  //     } else {
  //       emit(HideProgressBar());
  //       emit(OnFailure(error: states.statusMsg));
  //     }
  //   } catch (error) {
  //     GMLogger.v(error.toString());
  //     emit(HideProgressBar());
  //     emit(OnFailure(error: error.toString()));
  //   }
  // }
}
