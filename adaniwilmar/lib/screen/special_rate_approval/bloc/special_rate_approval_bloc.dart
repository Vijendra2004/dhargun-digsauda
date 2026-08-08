import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/special_rate_approval/bloc/special_rate_approval_event.dart';
import 'package:adaniwilmar/screen/special_rate_approval/bloc/special_rate_approval_state.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SpecialRateApprovalBloc
    extends Bloc<SpecialRateApprovalEvent, SpecialRateApprovalState> {
  SpecialRateApprovalBloc() : super(InitialSpecialRateApprovalState()) {
    on<LoadSpecialRateApprovalScreen>(
        (event, emit) => _getSpecialRateApprovalData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SpecialRateApprovalState get initialState =>
      InitialSpecialRateApprovalState();

  Future<void> _getSpecialRateApprovalData(LoadSpecialRateApprovalScreen event,
      Emitter<SpecialRateApprovalState> emit) async {
    try {
      emit(ShowProgressBar());
      String toDate=DateTimeUtils().dateToStringFormat(
          DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format);
      String fromDate= DateTimeUtils().dateToStringFormat(
    DateTime.now().add(Duration(days:Constants.REPORT_START_DAY)), DateTimeUtils.YYYY_MM_DD_Format);
      Meta metaSpecialRateList = await ServiceRepository()
          .getSpecialRateRequestList(
              Constants.AUTH_USERID, event.dealerId, fromDate, toDate);
      GMLogger.v("Dealer" + metaSpecialRateList.statusMsg);
      GMLogger.v("Dealer" + metaSpecialRateList.statusCode.toString());
      if(Constants.AUTH_ROLEID==Constants.DEALER){
        List<SpecialRateList> info = [];
        if (metaSpecialRateList.statusCode == 200) {
          jsonDecode(metaSpecialRateList.statusMsg)['response']
              .forEach((f) => info.add(SpecialRateList.fromJson(f)));
        }

        if (metaSpecialRateList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadDealerSuccess(sprateInfo: info));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaSpecialRateList.statusMsg));
        }
      }else {
        List<SpecialRateResponse> info = [];
        if (metaSpecialRateList.statusCode == 200) {
          jsonDecode(metaSpecialRateList.statusMsg)['response']
              .forEach((f) => info.add(SpecialRateResponse.fromJson(f)));
        }

        if (metaSpecialRateList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadSuccess(sprateInfo: info));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaSpecialRateList.statusMsg));
        }
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
