// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/sauda_extension_list.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_extension/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaExtensionBloc
    extends Bloc<SaudaExtensionEvent, SaudaExtensionState> {
  SaudaExtensionBloc() : super(InitialSaudaExtensionState()) {
    on<LoadSaudaExtensionScreen>(
        (event, emit) => _getSaudaExtensionData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SaudaExtensionState get initialState => InitialSaudaExtensionState();

  Future<void> _getSaudaExtensionData(
      LoadSaudaExtensionScreen event, Emitter<SaudaExtensionState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository()
          .getSaudaExtensionPendingAndApprovalListForBdo(
              event.userId, event.fromDate, event.toDate);
      GMLogger.v("Dealer" + metaSaudaList.statusMsg);
      GMLogger.v("Dealer" + metaSaudaList.statusCode.toString());
      if(Constants.AUTH_ROLEID==Constants.DEALER){
        DealerBookedSaudha info = DealerBookedSaudha(pendingList: [], approvedList: []);
        if (metaSaudaList.statusCode == 200) {
          info = DealerBookedSaudha.fromJson(
              jsonDecode(metaSaudaList.statusMsg)['response']);
        }

        if (metaSaudaList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnDealerLoadSuccess(bookedSaudha: info));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaSaudaList.statusMsg));
        }
      }else {
        BookedSaudha info = BookedSaudha(pendingList: [], approvedList: []);
        if (metaSaudaList.statusCode == 200) {
          info = BookedSaudha.fromJson(
              jsonDecode(metaSaudaList.statusMsg)['response']);
        }

        if (metaSaudaList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadSuccess(bookedSaudha: info));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaSaudaList.statusMsg));
        }
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
