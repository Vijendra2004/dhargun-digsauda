import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_history.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/allocation/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class AllocationBloc
    extends Bloc<AllocationEvent, AllocationState> {
  AllocationBloc() : super(InitialAllocationState()) {
    on<LoadSalesOrganization>(
            (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDealerSaudaDetail>(
            (event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>(
            (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadSKUDetails>((event, emit) => _getSKUData(event, emit));
    on<LoadZonalHead>((event, emit) => _getBDOList(event, emit));
    on<LoadAllocationScreen>(
            (event, emit) => _getDistributorList(event, emit));
    on<SaveQuantityLimit>(
            (event, emit) => _saveQuantityLimit(event, emit));
    on<UpdateQuantityLimit>(
            (event, emit) => _updateQuantityLimit(event, emit));
    on<SaveAllocateQuantityLimit>(
            (event, emit) => _saveAllocateQuantityLimit(event, emit));
    on<UpdateAssignedQuantityLimit>(
            (event, emit) => _updateAssignedQuantityLimit(event, emit));

    on<LoadUpdateQuantityLimitData>(
            (event, emit) => _getUpdateQuantityLimitData(event, emit));
    on<LoadUserQuantityLimitData>(
            (event, emit) => _getUserQuantityLimitData(event, emit));

  }
  AllocationState get initialState =>
      InitialAllocationState();

  Future<void> _getDistributorList(LoadAllocationScreen event,
      Emitter<AllocationState> emit) async {
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

  Future<void> _getSalesOrganization(LoadSalesOrganization event,
      Emitter<AllocationState> emit) async {
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

  Future<void> _getDistributorData(LoadDealerSaudaDetail event,
      Emitter<AllocationState> emit) async {
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

  Future<void> _getDistributionChannelData(LoadDistributionChannel event,
      Emitter<AllocationState> emit) async {
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
      LoadVerticalList event, Emitter<AllocationState> emit) async {
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

  Future<void> _saveQuantityLimit(SaveQuantityLimit event,
      Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().saveQuantityLimit(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveQuantityLimit(
            id: jsonDecode(savedSauda.statusMsg)['response']));
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

  Future<void> _updateQuantityLimit(UpdateQuantityLimit event,
      Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().updateQuantityLimit(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        if(jsonDecode(savedSauda.statusMsg)['response']["isSuccess"]){
              emit(OnSaveQuantityLimit(id:"" ));
        }else{
              emit(OnFailure(error: jsonDecode(savedSauda.statusMsg)['response']["errorDto"]["message"]));
        }
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

  Future<void> _saveAllocateQuantityLimit(SaveAllocateQuantityLimit event,
      Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().saveAllocateQuantityLimit(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        if(jsonDecode(savedSauda.statusMsg)['response']["isSuccess"]){
          emit(OnSaveQuantityLimit(id:"" ));
        }else{
          emit(OnFailure(error: jsonDecode(savedSauda.statusMsg)['response']["errorDto"]["message"]));
        }
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
  Future<void> _updateAssignedQuantityLimit(UpdateAssignedQuantityLimit event,
      Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().updateAssignedQuantityLimit(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        if(jsonDecode(savedSauda.statusMsg)['response']["isSuccess"]){
          emit(OnSaveQuantityLimit(id:"" ));
        }else{
          emit(OnFailure(error: jsonDecode(savedSauda.statusMsg)['response']["errorDto"]["message"]));
        }
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

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeListByLoginId(
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
  Future<void> _getSKUData(
      LoadSKUDetails event, Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList;
      metaSkuList = await ServiceRepository()
            .getOilTypeSkuList(
            Constants.AUTH_USERID,
            event.oilTypeId);
      List<BdoList> skuList = [];
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response']
            .forEach((f) => skuList.add(BdoList.fromJson(f)));
      }

      if (metaSkuList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSKUDetails(skuList: skuList));
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
  Future<void> _getBDOList(
      LoadZonalHead event, Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
      await ServiceRepository().getBDOListForTp(Constants.AUTH_USERID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<BdoList> bdoList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadZhList(zhList: bdoList));
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
  Future<void> _getUpdateQuantityLimitData(
      LoadUpdateQuantityLimitData event, Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository()
          .getQuantityLimitList(Constants.AUTH_USERID,event.assignedLimit);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        List<QuantityRequestList> quantityAllocation = [];
        if (meta.statusCode == 200) {
          jsonDecode(meta.statusMsg)['response'].forEach(
                  (f) => quantityAllocation.add(QuantityRequestList.fromJson(f)));
        }
        GMLogger.v(" res:" + quantityAllocation.toString());
        emit(OnUpdateQuantityLimitData(response: quantityAllocation));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getUserQuantityLimitData(
      LoadUserQuantityLimitData event, Emitter<AllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository()
          .getQuantityAllocationList(Constants.AUTH_USERID,0);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        List<QuantityRequestList> quantityAllocation = [];
        if (meta.statusCode == 200) {
          jsonDecode(meta.statusMsg)['response'].forEach(
                  (f) => quantityAllocation.add(QuantityRequestList.fromJson(f)));
        }
        GMLogger.v(" res:" + quantityAllocation.toString());
        emit(OnUserQuantityLimitData(response: quantityAllocation));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

}
