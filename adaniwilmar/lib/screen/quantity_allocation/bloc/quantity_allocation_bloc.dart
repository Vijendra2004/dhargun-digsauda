import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/quantity_allocation/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class QuantityAllocationBloc
    extends Bloc<QuantityAllocationEvent, QuantityAllocationState> {
  QuantityAllocationBloc() : super(InitialQuantityAllocationState()) {
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    on<LoadQuantityAllocationRequest>(
        (event, emit) => _getQuantityRequestList(event, emit));
    on<SaveQuantityRequest>((event, emit) => _saveQuantityRequest(event, emit));
  }
  QuantityAllocationState get initialState => InitialQuantityAllocationState();

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<QuantityAllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getOilTypeListByLoginId(Constants.AUTH_USERID);
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

  Future<void> _getOverallData(
      LoadOverallData event, Emitter<QuantityAllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository()
          .getQuantityAllocationList(Constants.AUTH_USERID, event.oilTypeId);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        if (Constants.AUTH_ROLEID == Constants.SALE) {
          List<DailySFQuantityAllocation> quantityAllocation = [];
          if (meta.statusCode == 200) {
            jsonDecode(meta.statusMsg)['response'].forEach((f) =>
                quantityAllocation.add(DailySFQuantityAllocation.fromJson(f)));
          }
          GMLogger.v(" res:" + quantityAllocation.toString());
          emit(OnOverallSuccess(response: quantityAllocation));
        } else {
          List<QuantityRequestList> quantityAllocation = [];
          if (meta.statusCode == 200) {
            jsonDecode(meta.statusMsg)['response'].forEach(
                (f) => quantityAllocation.add(QuantityRequestList.fromJson(f)));
          }
          GMLogger.v(" res:" + quantityAllocation.toString());
          emit(OnOverallManagerSuccess(response: quantityAllocation));
        }
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

  Future<void> _getQuantityRequestList(LoadQuantityAllocationRequest event,
      Emitter<QuantityAllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository()
          .getQuantityAllocationRequestStatusList(Constants.AUTH_USERID);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      List<SpecialtyFatQuantityRequestsList> quantityManagerList = [];
      if (Constants.SALE != Constants.AUTH_ROLEID) {
        Meta metaM = await ServiceRepository()
            .getQuantityAllocationManagerRequestStatusList(
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
        emit(OnQuantityAllocationRequestSuccess(
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
  }

  Future<void> _saveQuantityRequest(
      SaveQuantityRequest event, Emitter<QuantityAllocationState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda = await ServiceRepository().saveQuantityAllocationRequest(
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
  }
}
