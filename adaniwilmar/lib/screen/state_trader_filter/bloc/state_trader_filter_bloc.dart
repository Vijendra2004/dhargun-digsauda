import 'dart:async';
import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/state_trader_filter/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class StateTraderFilterBloc extends Bloc<StateTraderFilterEvent, StateTraderFilterState> {
  StateTraderFilterBloc() : super(InitialStateTraderFilterState()) {
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadZonalHead>((event, emit) => _getZonalHeadList(event, emit));
  }

  StateTraderFilterState get initialState => InitialStateTraderFilterState();

  Future<void> _getBdoList(LoadBDO event, Emitter<StateTraderFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      List<BdoList> bdoList = [];
      if (event.showAll) {
        BdoList defaultDist = BdoList();
        defaultDist.id = 0;
        defaultDist.name = "All State Traders";
        bdoList.add(defaultDist);
      }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => bdoList.add(BdoList.fromJson(f)));
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

  Future<void> _getZonalHeadList(LoadZonalHead event, Emitter<StateTraderFilterState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getZonalHeadList(event.userId);
      List<BdoList> zonalHeadList = [];
      if (event.showAll) {
        BdoList defaultDist = BdoList();
        defaultDist.id = 0;
        defaultDist.name = "All Zonal Traders";
        zonalHeadList.add(defaultDist);
      }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => zonalHeadList.add(BdoList.fromJson(f)));
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
}
