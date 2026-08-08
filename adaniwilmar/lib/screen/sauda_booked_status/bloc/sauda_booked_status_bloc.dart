// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/booked_sauda_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_booked_status/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaBookedStatusBloc
    extends Bloc<SaudaBookedStatusEvent, SaudaBookedStatusState> {
  SaudaBookedStatusBloc() : super(InitialSaudaBookedStatusState()) {
    on<LoadSaudaBookedStatusScreen>(
        (event, emit) => _getSaudaBookedStatusData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SaudaBookedStatusState get initialState => InitialSaudaBookedStatusState();

  Future<void> _getSaudaBookedStatusData(LoadSaudaBookedStatusScreen event,
      Emitter<SaudaBookedStatusState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository()
          .getBookedSauda(event.userId, event.fromDate, event.toDate,bdoId: event.bdoId);
      GMLogger.v("Dealer" + metaSaudaList.statusMsg);
      GMLogger.v("Dealer" + metaSaudaList.statusCode.toString());
      // BookedSaudha info = BookedSaudha(pendingList: [], approvedList: []);
      if(Constants.AUTH_ROLEID==Constants.DEALER){
        List<BookedSaudaResponse> response = [];
        if (metaSaudaList.statusCode == 200) {
          jsonDecode(metaSaudaList.statusMsg)['response'].forEach(
                  (f) =>
                  response.add(BookedSaudaResponse.fromJson(f)));
        }

        if (metaSaudaList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnDealerLoadSuccess(bookedSaudhas: response));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaSaudaList.statusMsg));
        }
      }else {
        List<SaudaBookedStatusDealerDetail> response = [];
        if (metaSaudaList.statusCode == 200) {
          jsonDecode(metaSaudaList.statusMsg)['response'].forEach(
                  (f) =>
                  response.add(SaudaBookedStatusDealerDetail.fromJson(f)));
        }

        if (metaSaudaList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadSuccess(bookedSaudhas: response));
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
