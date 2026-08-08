// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/sauda_extension_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/saudu_extension_details/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaExtensionDetailBloc
    extends Bloc<SaudaExtensionDetailEvent, SaudaExtensionDetailState> {
  SaudaExtensionDetailBloc() : super(InitialSaudaExtensionDetailState()) {
    on<LoadSaudaExtensionDetailScreen>(
        (event, emit) => _getSaudaExtensionDetailData(event, emit));
    on<SaveSaudaExtension>((event, emit) => _saveSaudaExtension(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadNewSaudaExtensionScreen>(
        (event, emit) => _getDistributorList(event, emit));
    on<LoadBdo>((event, emit) => _getBdoList(event, emit));
  }
  SaudaExtensionDetailState get initialState =>
      InitialSaudaExtensionDetailState();

  Future<void> _getDistributorList(LoadNewSaudaExtensionScreen event,
      Emitter<SaudaExtensionDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerByUserIdList(
          Constants.AUTH_USERID,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisonId,
          bdoIds: event.bdoId > 0 ? [event.bdoId] : []);
      List<DistributorList> distList = [];
      List<BdoList> bdoList = [];
      if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
        BdoList defaultBdo = BdoList();
        defaultBdo.id = 0;
        defaultBdo.name = "All State Traders";
        bdoList.add(defaultBdo);
        Meta metaBdoList =
            await ServiceRepository().getBDOList(Constants.AUTH_USERID);
        if (metaBdoList.statusCode == 200) {
          jsonDecode(metaBdoList.statusMsg)['response']
              .forEach((f) => bdoList.add(BdoList.fromJson(f)));
        }
      }
      DistributorList defaultDist = DistributorList();
      defaultDist.id = 0;
      defaultDist.employeeCode = "0";
      defaultDist.employeeName = "All Distributor";
      distList.add(defaultDist);
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(
            OnLoadNewSaudaSuccess(distributorList: distList, bdoList: bdoList));
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
      LoadBdo event, Emitter<SaudaExtensionDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      List<BdoList> bdoList = [];
      BdoList defaultBdo = BdoList();
      defaultBdo.id = 0;
      defaultBdo.name = "All State Traders";
      bdoList.add(defaultBdo);
      Meta metaBdoList =
          await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      if (metaBdoList.statusCode == 200) {
        jsonDecode(metaBdoList.statusMsg)['response']
            .forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }
      if (metaBdoList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadBDO(bdoList: bdoList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaBdoList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<SaudaExtensionDetailState> emit) async {
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
      OilType defaultType = OilType();
      defaultType.id = 0;
      defaultType.name = "All OilTypes";
      oilTypes.add(defaultType);
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

  Future<void> _getSaudaExtensionDetailData(
      LoadSaudaExtensionDetailScreen event,
      Emitter<SaudaExtensionDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository()
          .getBookedSaudaWithextensionDetailsList(event.userId,
              bdoId: event.bdoId,
              dealerId: event.dealerId,
              oilTypeId: event.oilTypeId);
      GMLogger.v("ext" + metaSaudaList.statusMsg);
      GMLogger.v("ext" + metaSaudaList.statusCode.toString());
      List<SaudaExtension> info = [];
      if (metaSaudaList.statusCode == 200) {
        jsonDecode(metaSaudaList.statusMsg)['response']
            .forEach((f) => info.add(SaudaExtension.fromJson(f)));
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(saudaExtensions: info));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveSaudaExtension(
      SaveSaudaExtension event, Emitter<SaudaExtensionDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().saveSaudaExtension(event.request);
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
