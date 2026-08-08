// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/your_sales_performance_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/your_performance/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class YourPerformanceBloc
    extends Bloc<YourPerformanceEvent, YourPerformanceState> {
  YourPerformanceBloc() : super(InitialYourPerformanceState()) {
    on<LoadYourPerformanceScreen>(
        (event, emit) => _getYourPerformanceData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  YourPerformanceState get initialState => InitialYourPerformanceState();

  Future<void> _getYourPerformanceData(LoadYourPerformanceScreen event,
      Emitter<YourPerformanceState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository().getYourSalesPerformance(
          event.userId,
          event.fromDate,
          event.toDate,
          event.roleId,
          event.isShowDealer);
      GMLogger.v("Dealer" + metaSaudaList.statusMsg);
      GMLogger.v("Dealer" + metaSaudaList.statusCode.toString());
      YourSalesPerformance info = YourSalesPerformance();
      List<YourSalesPerformance> rankingList = [];
      if (metaSaudaList.statusCode == 200) {
        info = YourSalesPerformance.fromJson(
            jsonDecode(metaSaudaList.statusMsg)['response']);
      }

      Meta ranks = await ServiceRepository().getYourSalesPerformanceRank(
          event.userId,
          event.fromDate,
          event.toDate,
          event.roleId,
          event.isShowDealer);
      GMLogger.v("ranks" + ranks.statusMsg);
      GMLogger.v("oil" + ranks.statusCode.toString());
      if (ranks.statusCode == 200) {
        jsonDecode(ranks.statusMsg)['response']
            .forEach((f) => rankingList.add(YourSalesPerformance.fromJson(f)));
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(salesPerformance: info, rankingList: rankingList));
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
