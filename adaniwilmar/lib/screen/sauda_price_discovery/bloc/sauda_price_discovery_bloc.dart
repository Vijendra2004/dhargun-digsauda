import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/competitor_list.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_price_discovery/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaPriceDiscoveryBloc
    extends Bloc<SaudaPriceDiscoveryEvent, SaudaPriceDiscoveryState> {
  SaudaPriceDiscoveryBloc() : super(InitialSaudaPriceDiscoveryState()) {
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadSaudaPriceDiscoveryScreen>(
        (event, emit) => _getCompetitorList(event, emit));
    on<LoadSKUDetails>((event, emit) => _getSKUData(event, emit));
    on<SavePriceDiscovery>((event, emit) => _savePriceDiscovery(event, emit));
  }
  SaudaPriceDiscoveryState get initialState =>
      InitialSaudaPriceDiscoveryState();

  Future<void> _getCompetitorList(LoadSaudaPriceDiscoveryScreen event,
      Emitter<SaudaPriceDiscoveryState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getCompetitorList(Constants.AUTH_USERID);
      List<CompetitorList> compList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => compList.add(CompetitorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(competitorList: compList));
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

  Future<void> _getSKUData(
      LoadSKUDetails event, Emitter<SaudaPriceDiscoveryState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList =
          await ServiceRepository().getSkuByOilType(event.oilTypeId);
      List<OilTypeSkuList> skuList = [];
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response']
            .forEach((f) => skuList.add(OilTypeSkuList.fromJson(f)));
      }

      if (metaSkuList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSKUDetails(
            skuList: skuList, currentIndex: event.currentIndex));
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

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<SaudaPriceDiscoveryState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeListByLoginId(
          Constants.AUTH_USERID,
          salesOrgId: 0,
          distriChannelId: 0,
          divisionId: 0);
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

  Future<void> _savePriceDiscovery(
      SavePriceDiscovery event, Emitter<SaudaPriceDiscoveryState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().savePriceDiscovery(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSavePriceDiscovery(
            response: jsonDecode(savedSauda.statusMsg)['response']));
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
