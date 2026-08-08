import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/over_due/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class OverDueBloc extends Bloc<OverDueEvent, OverDueState> {
  OverDueBloc() : super(InitialOverDueState()) {
    on<LoadOverDueScreen>((event, emit) => _getDistributorData(event, emit));
    on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }

  OverDueState get initialState => InitialOverDueState();

  Future<void> _getDistributorData(LoadOverDueScreen event, Emitter<OverDueState> emit) async {
    try {
      emit(ShowProgressBar());
      if (Constants.AUTH_ROLEID != Constants.DEALER) {
        Meta metaDealerList = await ServiceRepository().getDealerByUserIdList(Constants.AUTH_USERID, 0, 0, 0, bdoIds: event.bdoId > 0 ? [event.bdoId] : []);
        GMLogger.v("Dealer" + metaDealerList.statusMsg);
        GMLogger.v("Dealer" + metaDealerList.statusCode.toString());
        List<DistributorList> distList = [];
        if (metaDealerList.statusCode == 200) {
          jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => distList.add(DistributorList.fromJson(f)));
        }

        if (metaDealerList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadSuccess(distributorList: distList));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaDealerList.statusMsg));
        }
      } else {
        emit(HideProgressBar());
        emit(OnLoadSuccess(distributorList: []));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getOverallData(LoadOverallData event, Emitter<OverDueState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository().getTomorrowDueList(Constants.AUTH_USERID, event.dealerId, dueStatus: event.statusId);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        DueForTomorrowList response = DueForTomorrowList();
        response = DueForTomorrowList.fromJson(jsonDecode(meta.statusMsg)['response']);
        GMLogger.v(" res:" + response.toString());
        emit(OnOverallSuccess(response: response, statusId: event.statusId));
      } else {
        emit(HideProgressBar());
        DueForTomorrowList response = DueForTomorrowList();
        emit(OnOverallSuccess(response: response, statusId: event.statusId));
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
