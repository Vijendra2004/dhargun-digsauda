// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_detail_view/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaDetailViewBloc
    extends Bloc<SaudaDetailViewEvent, SaudaDetailViewState> {
  SaudaDetailViewBloc() : super(InitialSaudaDetailViewState()) {
    on<LoadSaudaDetailViewScreen>(
        (event, emit) => _getSaudaDetailViewData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SaudaDetailViewState get initialState => InitialSaudaDetailViewState();

  Future<void> _getSaudaDetailViewData(LoadSaudaDetailViewScreen event,
      Emitter<SaudaDetailViewState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository()
          .getSaudaOrderDetail(event.userId, event.saudaId);
      GMLogger.v("Dealer" + metaSaudaList.statusMsg);
      GMLogger.v("Dealer" + metaSaudaList.statusCode.toString());
      // BookedSaudha info = BookedSaudha(pendingList: [], approvedList: []);
      SaudaDetailResponse response = SaudaDetailResponse();
      if (metaSaudaList.statusCode == 200) {
        response = SaudaDetailResponse.fromJson(
            jsonDecode(metaSaudaList.statusMsg)['response']);
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(saudaDetailResponse: response));
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
}
