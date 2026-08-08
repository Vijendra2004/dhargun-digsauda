import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/secondary_sales/bloc/secondary_sales_event.dart';
import 'package:adaniwilmar/screen/secondary_sales/bloc/secondary_sales_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SecondarySalesBloc
    extends Bloc<SecondarySalesEvent, SecondarySalesState> {
  SecondarySalesBloc() : super(InitialSecondarySalesState()) {
    on<LoadSecondarySalesScreen>(
        (event, emit) => _getSecondarySalesData(event, emit));
  }
  SecondarySalesState get initialState => InitialSecondarySalesState();

  Future<void> _getSecondarySalesData(
      LoadSecondarySalesScreen event, Emitter<SecondarySalesState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSpecialRateList = await ServiceRepository()
          .getSecondarySalesFortheDayList(Constants.AUTH_USERID);
      GMLogger.v("Dealer" + metaSpecialRateList.statusMsg);
      GMLogger.v("Dealer" + metaSpecialRateList.statusCode.toString());
      List<SecondarySalesFortheDayViewDto> info = [];
      if (metaSpecialRateList.statusCode == 200) {
        jsonDecode(metaSpecialRateList.statusMsg)['response'].forEach(
            (f) => info.add(SecondarySalesFortheDayViewDto.fromJson(f)));
      }

      if (metaSpecialRateList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(secondarySales: info));
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
