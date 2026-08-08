// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/stp/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class StpBloc extends Bloc<StpEvent, StpState> {
  StpBloc() : super(InitialStpState()) {
    on<LoadStpScreen>((event, emit) => _getStpData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  StpState get initialState => InitialStpState();

  Future<void> _getStpData(LoadStpScreen event, Emitter<StpState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaChart = await ServiceRepository().getSalesTourPlanChart(
          event.userId, event.fromDate, event.toDate, event.financialYearId);
      GMLogger.v("STP" + metaChart.statusMsg);
      GMLogger.v("STP" + metaChart.statusCode.toString());
      List<SalesTourPlanChartViewDto> info = [];
      if (metaChart.statusCode == 200) {
        jsonDecode(metaChart.statusMsg)['response']
            .forEach((f) => info.add(SalesTourPlanChartViewDto.fromJson(f)));
      }

      if (metaChart.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(chartData: info));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaChart.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
