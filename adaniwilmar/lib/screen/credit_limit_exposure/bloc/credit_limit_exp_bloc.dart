import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/credit_limit_exposure_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/credit_limit_exposure/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class CreditLimitExposureBloc
    extends Bloc<CreditLimitExposureEvent, CreditLimitExposureState> {
  CreditLimitExposureBloc() : super(InitialCreditLimitExposureState()) {
    on<LoadCreditLimitExposureList>(
        (event, emit) => _getDistributorList(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadCreditLimitExposureSalesScreen>(
        (event, emit) => _getCreditLimitExposureSalesData(event, emit));
  }
  CreditLimitExposureState get initialState =>
      InitialCreditLimitExposureState();

  Future<void> _getCreditLimitExposureSalesData(
      LoadCreditLimitExposureSalesScreen event,
      Emitter<CreditLimitExposureState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getCreditLimitExposure(event.bdoIds, event.dealerIds, 1);
      List<CreditLimitExposure> creditList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => creditList.add(CreditLimitExposure.fromJson(f)));
      }
      Meta metaExposureList = await ServiceRepository()
          .getCreditLimitExposure(event.bdoIds, event.dealerIds, 2);
      List<CreditLimitExposure> creditExposures = [];
      if (metaExposureList.statusCode == 200) {
        jsonDecode(metaExposureList.statusMsg)['response'].forEach(
            (f) => creditExposures.add(CreditLimitExposure.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(
            creditLimits: creditList, creditExposure: creditExposures));
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

  Future<void> _getDistributorList(LoadCreditLimitExposureList event,
      Emitter<CreditLimitExposureState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getDealerByUserIdList(Constants.AUTH_USERID, 0, 0, 0);
      GMLogger.v("Dealer123" + metaDealerList.statusMsg);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadCreditLimitExposure(distributorList: distList));
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
