import 'dart:convert';
import 'package:adaniwilmar/models/RolesResponse.dart';
import 'package:adaniwilmar/models/SaveSaudaRestReqmodel.dart';
import 'package:adaniwilmar/models/StateTraderModel.dart';
import 'package:adaniwilmar/screen/sauda_restrictions/sauda_restiction_add/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../gmcore/model/Meta.dart';
import '../../../../gmcore/network/GMLogger.dart';
import '../../../../repo/service_repository.dart';
import 'sauda_restriction_add_screen_event.dart';
import 'sauda_restriction_add_screen_state.dart';

class SaudaRestrictionAddScreenBloc extends Bloc<SaudaRestrictionAddScreenEvent,
    SaudaRestrictionAddScreenState> {
  SaudaRestrictionAddScreenBloc() : super(SaudaAddResScreenInitial()) {
    on<LoadRolesList>((event, emit) => _getRolesApi(event, emit));
    on<LoadStateTraderList>((event, emit) => _getStateTraderApi(event, emit));
    on<LoadZoneTraderList>((event, emit) => _getZoneTraderApi(event, emit));
    on<LoadDistributorList>((event, emit) => _getDistributorsList(event, emit));
    on<LoadRestrictionOilType>((event, emit) => _getOilTypeApi(event, emit));
    on<OnSaveSaudaRestriction>((event, emit) => _saveSaudaRestrictionApi(event, emit));
    on<OnUpdateSaudaRestriction>((event, emit) => _updateSaudaRestriction(event, emit));
  }

  Future<void> _getRolesApi(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().getAddResRolesApi();
      List<RoleItem>? rolesItems = [];
      if (metaSaudaList.statusCode == 200) {
        rolesItems = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => RoleItem.fromJson(e))
            .toList();
      }

      if (metaSaudaList.statusCode == 200) {
          emit(HideAddResProgressBar());
          emit(OnAddResSuccess(rolesList: rolesItems));
        } else {
          emit(HideAddResProgressBar());
          emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
        }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getStateTraderApi(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().getStateTraderListApi();
      List<TradersNameItems>? stateTraderItem = [];
      if (metaSaudaList.statusCode == 200) {
        stateTraderItem = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => TradersNameItems.fromJson(e))
            .toList();
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideAddResProgressBar());
        emit(OnStateTraderResponse(items: stateTraderItem));
      } else {
        emit(HideAddResProgressBar());
        emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getZoneTraderApi(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().getZonalTraderApi();
      List<TradersNameItems>? zoneTraderItems = [];
      if (metaSaudaList.statusCode == 200) {
        zoneTraderItems = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => TradersNameItems.fromJson(e))
            .toList();
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideAddResProgressBar());
        emit(OnZoneTraderResponse(zoneItems: zoneTraderItems));
      } else {
        emit(HideAddResProgressBar());
        emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getDistributorsList(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().getDistributorsList();
      List<TradersNameItems>? distributorsItems = [];
      if (metaSaudaList.statusCode == 200) {
        distributorsItems = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => TradersNameItems.fromJson(e))
            .toList();
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideAddResProgressBar());
        emit(OnDistributorsResponse(distributorsItems: distributorsItems));
      } else {
        emit(HideAddResProgressBar());
        emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _getOilTypeApi(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().getOilTypeApi();
      List<TradersNameItems>? oilItems = [];
      if (metaSaudaList.statusCode == 200) {
        oilItems = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => TradersNameItems.fromJson(e))
            .toList();
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideAddResProgressBar());
        emit(OnOilResponse(oilItems: oilItems));
      } else {
        emit(HideAddResProgressBar());
        emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _saveSaudaRestrictionApi(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      SaveSaudaRestReqmodel reqmodel = event.props[0] as SaveSaudaRestReqmodel;
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().saveSaudaRestriction(reqmodel);
      if (metaSaudaList.statusCode == 200) {
        String responseMsg = jsonDecode(metaSaudaList.statusMsg)['response'];
        emit(HideAddResProgressBar());
        emit(OnRestSaveSuccess(message: responseMsg));
      } else {
        emit(HideAddResProgressBar());
        emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }

  Future<void> _updateSaudaRestriction(SaudaRestrictionAddScreenEvent event,
      Emitter<SaudaRestrictionAddScreenState> emit) async {
    try {
      SaveSaudaRestReqmodel reqmodel = event.props[0] as SaveSaudaRestReqmodel;
      emit(ShowAddResProgressBar());
      Meta metaSaudaList = await ServiceRepository().saveandUpdateRestriction(reqmodel);
      if (metaSaudaList.statusCode == 200) {
        String responseMsg = jsonDecode(metaSaudaList.statusMsg)['response'];
        emit(HideAddResProgressBar());
        emit(OnUpdateResponse(message: responseMsg));
      } else {
        emit(HideAddResProgressBar());
        emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideAddResProgressBar());
      emit(OnResFailure(errorMessage: error.toString()));
    }
  }



}
