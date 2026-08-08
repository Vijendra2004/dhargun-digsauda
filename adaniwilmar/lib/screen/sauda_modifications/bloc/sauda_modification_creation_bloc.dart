import 'dart:convert';

import 'package:adaniwilmar/models/ContractNoModel.dart';
import 'package:adaniwilmar/models/DistributorListModel.dart';
import 'package:adaniwilmar/models/ModOilMaterialResponse.dart';
import 'package:adaniwilmar/models/OilResponseModel.dart';
import 'package:adaniwilmar/screen/sauda_modifications/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/ToSKUUpdateModel.dart';
import '../../../models/toSkuResponseModel.dart';
import '../../../repo/service_repository.dart';
import 'sauda_moddification_creation_event.dart';
import 'sauda_modification_creation_state.dart';

class SaudaModAddScreenBloc extends Bloc<SaudaModificationAddScreenEvent,
    SaudaModificationAddScreenState> {
  SaudaModAddScreenBloc() : super(SaudaModScreenInitial()) {
    on<LoadModDealersList>((event, emit) => _getDistributorApiCall(event, emit));
    on<LoadContractNumbers>((event, emit) => _getContractNumberApiCall(event, emit));
    on<LoadOilAndMaterialAPI>((event, emit) => _getOilMaterialAPI(event, emit));
    on<LoadListofOilItems>((event, emit) => _getOilListItems(event, emit));
    on<LoadToSkuFromOIL>((event, emit) => _getToSkuFromOilApiCall(event, emit));
    on<CreateSaudaModificationEvent>((event, emit) => _saveSaudaModificationApi(event, emit));
    on<GetToSkuList>((event, emit) => _getToSkuList(event, emit));
  }


  Future<void> _getDistributorApiCall(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().getDistributorApi();
      List<DistributorListItem>? distItems = [];
      if (metaSaudaList.statusCode == 200) {
        distItems = (jsonDecode(metaSaudaList.statusMsg)['response']['result'] as List)
            .map((e) => DistributorListItem.fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
          emit(HideModProgressBar());
          emit(OnDisModSuccess(distItems: distItems));
        } else {
          emit(HideModProgressBar());
          emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
        }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getContractNumberApiCall(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().getContractNumber(event.props);
      List<ContractNoItem>? contractItem = [];
      if (metaSaudaList.statusCode == 200) {
        contractItem = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => ContractNoItem.fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
        emit(HideModProgressBar());
        emit(onLoadContractNumbers(contractItem: contractItem));
      } else {
        emit(HideModProgressBar());
        emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getOilListItems(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().getOilListApi(event.props);
      List<OilType>? oilResponseModel = [];
      if (metaSaudaList.statusCode == 200) {
        oilResponseModel = (jsonDecode(metaSaudaList.statusMsg)['response']["oilTypes"] as List)
            .map((e) => OilType.fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
        emit(HideModProgressBar());
        emit(OnLoadOilListItems(oilNoItems:oilResponseModel));
      } else {
        emit(HideModProgressBar());
        emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getOilMaterialAPI(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().getModOilMaterialAPi(event.props);
      List<ModOilMaterial>? modOilMaterial = [];
      if (metaSaudaList.statusCode == 200) {
        modOilMaterial = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => ModOilMaterial.fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
        emit(HideModProgressBar());
        emit(OnLoadModOilList(oiltItems: modOilMaterial));
      } else {
        emit(HideModProgressBar());
        emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getToSkuFromOilApiCall(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().getToSkuFromOilApiCall(event.props);
      List<ToSkuItemResp>? toSkuItemsList = [];
      if (metaSaudaList.statusCode == 200) {
        toSkuItemsList = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => ToSkuItemResp .fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
        emit(HideModProgressBar());
        emit(onLoadToSkuItems(toSkuItems: toSkuItemsList));
      } else {
        emit(HideModProgressBar());
        emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _saveSaudaModificationApi(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().saveSaudaModificationApi(event.props);
      if (metaSaudaList.statusCode == 200) {
        emit(HideModProgressBar());
        emit(OnSaudaModCreationSuccess(message: "Sauda Modification Created Successfully"));
      } else {
        emit(HideModProgressBar());
        emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getToSkuList(SaudaModificationAddScreenEvent event,
      Emitter<SaudaModificationAddScreenState> emit) async {
    try {
      emit(ShowModProgressBar());
      Meta metaSaudaList = await ServiceRepository().getToSkuList(event.props);
      List<ToSKUItem>? toSkuItemsList = [];
      if (metaSaudaList.statusCode == 200) {
        toSkuItemsList = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => ToSKUItem .fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
        emit(HideModProgressBar());
        emit(OnSaudaModificationToSku(skuItem: toSkuItemsList));
      } else {
        emit(HideModProgressBar());
        emit(OnModResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideModProgressBar());
      emit(OnModResFailure(errorMessage: error.toString()));
    }
  }



}
