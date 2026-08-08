import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/saudu_number/bloc/sauda_number_event.dart';
import 'package:adaniwilmar/screen/saudu_number/bloc/sauda_number_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaNumberBloc extends Bloc<SaudaNumberEvent, SaudaNumberState> {
  SaudaNumberBloc() : super(InitialSaudaNumberState()) {
    on<LoadSaudaNumberScreen>(
        (event, emit) => _getSaudaNumberData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SaudaNumberState get initialState => InitialSaudaNumberState();

  Future<void> _getSaudaNumberData(
      LoadSaudaNumberScreen event, Emitter<SaudaNumberState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSpecialRateList = await ServiceRepository()
          .getSpecialRateRequestList(
              Constants.AUTH_USERID, event.dealerId, "", "");
      GMLogger.v("Dealer" + metaSpecialRateList.statusMsg);
      GMLogger.v("Dealer" + metaSpecialRateList.statusCode.toString());
      List<SpecialRate> info = [];
      if (metaSpecialRateList.statusCode == 200) {
        jsonDecode(metaSpecialRateList.statusMsg)['response']
            .forEach((f) => info.add(SpecialRate.fromJson(f)));
      }

      if (metaSpecialRateList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(sprateInfo: info));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSpecialRateList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
