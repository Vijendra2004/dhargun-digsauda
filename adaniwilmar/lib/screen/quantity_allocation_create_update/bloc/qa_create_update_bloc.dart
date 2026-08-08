import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gmcore/network/GMLogger.dart';
import '../../../models/bdo_list_response.dart';
import '../../../models/daily_rate_response.dart';
import '../../../models/qa_list_model.dart';
import 'bloc.dart';

class QACreateUpdateBloc
    extends Bloc<QACreateUpdateEvent, QACreateUpdateState> {
  QACreateUpdateBloc() : super(InitialQuantityAllocationCreateUpdateState()) {
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    on<LoadQAItemFetch>(
        (event, emit) => _getQAItem(event, emit));
    on<SaveQuantityRequest>((event, emit) => _saveQuantityRequest(event, emit));
    on<LoadSalesOrganization>(
            (event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>(
            (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<OnLoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<OnLoadSubCategory>((event, emit) => _getSubCategory(event, emit));
    on<OnLoadMaterialDDList>((event, emit) => _getMaterialDropDown(event, emit));
    on<LoadZonalEmployees>((event, emit) => _getZonalEmployeesList(event, emit));

  }
  QACreateUpdateState get initialState => InitialQuantityAllocationCreateUpdateState();


  // Future<void> _getOverallData(
  //     LoadOverallData event, Emitter<QuantityAllocationCreateUpdateState> emit) async {
  //   try {
  //     emit(ShowProgressBar());
  //     Meta meta = await ServiceRepository()
  //         .getQuantityAllocationCreateUpdateList(Constants.AUTH_USERID, event.oilTypeId);
  //     GMLogger.v(meta.statusMsg);
  //     GMLogger.v(meta.statusCode.toString());
  //     if (meta.statusCode == 200) {
  //       emit(HideProgressBar());
  //       if (Constants.AUTH_ROLEID == Constants.SALE) {
  //         List<DailySFQuantityAllocationCreateUpdate> quantityAllocation = [];
  //         if (meta.statusCode == 200) {
  //           jsonDecode(meta.statusMsg)['response'].forEach((f) =>
  //               quantityAllocation.add(DailySFQuantityAllocationCreateUpdate.fromJson(f)));
  //         }
  //         GMLogger.v(" res:" + quantityAllocation.toString());
  //         emit(OnOverallSuccess(response: quantityAllocation));
  //       } else {
  //         List<QuantityRequestList> quantityAllocation = [];
  //         if (meta.statusCode == 200) {
  //           jsonDecode(meta.statusMsg)['response'].forEach(
  //               (f) => quantityAllocation.add(QuantityRequestList.fromJson(f)));
  //         }
  //         GMLogger.v(" res:" + quantityAllocation.toString());
  //         emit(OnOverallManagerSuccess(response: quantityAllocation));
  //       }
  //     } else {
  //       emit(HideProgressBar());
  //       emit(OnFailure(error: meta.statusMsg));
  //     }
  //   } catch (error) {
  //     GMLogger.v(error.toString());
  //     emit(HideProgressBar());
  //     emit(OnFailure(error: error.toString()));
  //   }
  // }

 /* Future<void> _getQuantityRequestList(LoadQuantityAllocationCreateUpdateRequest event,
      Emitter<QuantityAllocationCreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository()
          .getQuantityAllocationCreateUpdateRequestStatusList(Constants.AUTH_USERID);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      List<SpecialtyFatQuantityRequestsList> quantityManagerList = [];
      if (Constants.SALE != Constants.AUTH_ROLEID) {
        Meta metaM = await ServiceRepository()
            .getQuantityAllocationCreateUpdateManagerRequestStatusList(
                Constants.AUTH_USERID);
        GMLogger.v("mmmmm" + metaM.statusMsg);
        GMLogger.v("mmmmm" + metaM.statusCode.toString());
        if (metaM.statusCode == 200) {
          jsonDecode(metaM.statusMsg)['response'].forEach((f) =>
              quantityManagerList
                  .add(SpecialtyFatQuantityRequestsList.fromJson(f)));
        }
      }
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        List<SpecialtyFatQuantityRequestsList> quantityAllocation = [];
        if (meta.statusCode == 200) {
          jsonDecode(meta.statusMsg)['response'].forEach((f) =>
              quantityAllocation
                  .add(SpecialtyFatQuantityRequestsList.fromJson(f)));
        }
        GMLogger.v(" res:" + quantityAllocation.toString());
        emit(OnQuantityAllocationCreateUpdateRequestSuccess(
            quantityRequestList: quantityAllocation,
            quantityManagerRequestList: quantityManagerList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }*/

  /*Future<void> _saveQuantityRequest(
      SaveQuantityRequest event, Emitter<QuantityAllocationCreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda = await ServiceRepository().saveQuantityAllocationCreateUpdateRequest(
          event.userId,
          event.oilTypeId,
          event.specialtyLimitId,
          event.skuId,
          event.quantity);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(const OnSaveSuccess(saved: true));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }*/

  Future<void> _getDistributorData(
      LoadSalesOrganization event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getSalesOrganizationQA();
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


  Future<void> _getDistributionChannelData(
      LoadDistributionChannel event, Emitter<QACreateUpdateState> emit) async {
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
      LoadVerticalList event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
      await ServiceRepository().getVertical(event.distributionId, isFromQuantityAllocationCreateUpdate: true);
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
      OnLoadOilType event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeList(
          Constants.AUTH_USERID,
          // salesOrgId: event.salesOrganizationId,
          // distriChannelId: event.distributionChannelId,
          divisionId: event.divisonId,
      isFromQuantityAllocationCreateUpdate: true);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<OilType> oilTypes = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => oilTypes.add(OilType.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilTypes(oilTypes: oilTypes));
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




  Future<void> _getSubCategory(
      OnLoadSubCategory event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
      await ServiceRepository().getSubCategory();
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


  Future<void> _getMaterialDropDown(
      OnLoadMaterialDDList event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta =
      await ServiceRepository().getMaterialDropDownList(event.oilTypeId??"");
      GMLogger.v("list" + meta.statusMsg);
      GMLogger.v("list" + meta.statusCode.toString());
      List<BdoList> materialList = [];
      if (meta.statusCode == 200) {
        jsonDecode(meta.statusMsg)['response']
            .forEach((f) => materialList.add(BdoList.fromJson(f)));
      }
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadMaterial(metrialList: materialList));
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

  Future<void> _getZonalEmployeesList(
      LoadZonalEmployees event, Emitter<QACreateUpdateState> emit) async {
  try {
      emit(ShowProgressBar());
      Meta metaZonalEmpList = await ServiceRepository().getZonalEmployeesList(
        Constants.AUTH_USERID,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisonId,
        isFromQuantityAllocationCU:true,
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



Future<void> _saveQuantityRequest(
      SaveQuantityRequest event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda = await ServiceRepository().saveQuantityAllocationCreateUpdateRequest(event.allocationCreateReq);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(const OnSaveSuccess(saved: true));
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

  _getQAItem(LoadQAItemFetch event, Emitter<QACreateUpdateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository()
          .listQAItemFetch(event.id);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      if (meta.statusCode == 200) {
      QAListResponseValue listModel = QAListResponseValue();
      listModel =   QAListResponseValue.fromJson(jsonDecode(meta.statusMsg)['response']);


        emit(HideProgressBar());
        emit(OnLoadQAItemFetch(listModel:listModel));


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
