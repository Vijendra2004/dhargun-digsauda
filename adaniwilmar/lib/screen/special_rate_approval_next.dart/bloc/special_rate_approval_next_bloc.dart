import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/special_rate_approval_next.dart/bloc/special_rate_approval_next_event.dart';
import 'package:adaniwilmar/screen/special_rate_approval_next.dart/bloc/special_rate_approval_next_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';
import '../../../models/special_rate_view_response.dart';

class SpecialRateApprovalViewBloc
    extends Bloc<SpecialRateApprovalViewEvent, SpecialRateApprovalViewState> {
  SpecialRateApprovalViewBloc() : super(InitialSpecialRateApprovalViewState()) {
    on<LoadSpecialRateApprovalViewScreen>(
        (event, emit) => _getSpecialRateApprovalViewData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SpecialRateApprovalViewState get initialState =>
      InitialSpecialRateApprovalViewState();

  Future<void> _getSpecialRateApprovalViewData(
      LoadSpecialRateApprovalViewScreen event,
      Emitter<SpecialRateApprovalViewState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSpecialRateList = await ServiceRepository()
          .getSpecialRateRequestView(
              Constants.AUTH_USERID, event.dealerId, event.specialRateId);
      GMLogger.v("Dealer" + metaSpecialRateList.statusMsg);
      GMLogger.v("Dealer" + metaSpecialRateList.statusCode.toString());
      SpecialRateView info = SpecialRateView();
      if (metaSpecialRateList.statusCode == 200) {
        info = SpecialRateView.fromJson(
            jsonDecode(metaSpecialRateList.statusMsg)['response']);
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
