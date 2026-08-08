// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/models/lifting_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_sales_order_status/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaSalesOrderStatusBloc
    extends Bloc<SaudaSalesOrderStatusEvent, SaudaSalesOrderStatusState> {
  SaudaSalesOrderStatusBloc() : super(InitialSaudaSalesOrderStatusState()) {
    on<LoadSaudaSalesOrderStatusScreen>(
        (event, emit) => _getSaudaSalesOrderStatusData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SaudaSalesOrderStatusState get initialState =>
      InitialSaudaSalesOrderStatusState();

  Future<void> _getSaudaSalesOrderStatusData(
      LoadSaudaSalesOrderStatusScreen event,
      Emitter<SaudaSalesOrderStatusState> emit) async {
    try {
      emit(ShowProgressBar());
      if(Constants.DEALER==Constants.AUTH_ROLEID){
        String toDate=DateTimeUtils().dateToStringFormat(
            DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format);
        String fromDate= DateTimeUtils().dateToStringFormat(
            DateTime.now().add(Duration(days:-100)), DateTimeUtils.YYYY_MM_DD_Format);
        Meta metaRequestList = await ServiceRepository()
            .getLiftingRequestList(event.userId, event.bdoId, event.statusId,fromDate: fromDate,toDate: toDate);
        GMLogger.v("Req" + metaRequestList.statusMsg);
        GMLogger.v("Req" + metaRequestList.statusCode.toString());
        List<DealerLiftingResponse> response = [];
        if (metaRequestList.statusCode == 200) {
          jsonDecode(metaRequestList.statusMsg)['response']
              .forEach((f) => response.add(DealerLiftingResponse.fromJson(f)));
        }

        if (metaRequestList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadDealerSuccess(liftingResponse: response,statusId: event.statusId));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaRequestList.statusMsg));
        }

      }else{
        Meta metaRequestList = await ServiceRepository()
            .getLiftingRequestList(event.userId, event.bdoId, event.statusId);
        GMLogger.v("Req" + metaRequestList.statusMsg);
        GMLogger.v("Req" + metaRequestList.statusCode.toString());
        List<LiftingResponse> response = [];
        if (metaRequestList.statusCode == 200) {
          jsonDecode(metaRequestList.statusMsg)['response']
              .forEach((f) => response.add(LiftingResponse.fromJson(f)));
        }

        if (metaRequestList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadSuccess(liftingResponse: response,statusId: event.statusId));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaRequestList.statusMsg));
        }
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
