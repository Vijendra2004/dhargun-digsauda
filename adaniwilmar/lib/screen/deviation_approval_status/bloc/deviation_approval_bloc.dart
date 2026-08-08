import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/deviation_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/deviation_approval_status/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class DeviationApprovalBloc
    extends Bloc<DeviationApprovalEvent, DeviationApprovalState> {
  DeviationApprovalBloc() : super(InitialDeviationApprovalState()) {
    on<LoadDeviationApprovalScreen>(
        (event, emit) => _getDeviationData(event, emit));
  }
  DeviationApprovalState get initialState => InitialDeviationApprovalState();

  Future<void> _getDeviationData(LoadDeviationApprovalScreen event,
      Emitter<DeviationApprovalState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDeviationList =
          await ServiceRepository().getApprovedMPDList(Constants.AUTH_USERID);
      GMLogger.v("Dealer" + metaDeviationList.statusMsg);
      GMLogger.v("Dealer" + metaDeviationList.statusCode.toString());
      List<DeviationResponse> deviationList = [];
      if (metaDeviationList.statusCode == 200) {
        jsonDecode(metaDeviationList.statusMsg)['response']
            .forEach((f) => deviationList.add(DeviationResponse.fromJson(f)));
      }

      metaDeviationList =
          await ServiceRepository().getPendingMPDList(Constants.AUTH_USERID);
      GMLogger.v("Dealer" + metaDeviationList.statusMsg);
      GMLogger.v("Dealer" + metaDeviationList.statusCode.toString());
      List<DeviationResponse> pendingDeviationList = [];
      if (metaDeviationList.statusCode == 200) {
        jsonDecode(metaDeviationList.statusMsg)['response'].forEach(
            (f) => pendingDeviationList.add(DeviationResponse.fromJson(f)));
      }

      if (metaDeviationList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(
            deviationList: deviationList,
            pendingDeviationList: pendingDeviationList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDeviationList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
