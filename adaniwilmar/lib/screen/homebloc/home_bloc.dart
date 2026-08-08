import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/overall_response.dart';
import 'package:adaniwilmar/models/statistics_response.dart';
import 'package:adaniwilmar/models/ticker_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/homebloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../gmcore/network/GMLogger.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<LoadHomeScreen>((event, emit) => _getDashboardData(event, emit));
    on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    on<LoadUserStatistics>((event, emit) => _getStatistics(event, emit));
    on<LoadLastAliveTime>((event, emit) => _getLastAliveTime(event, emit));
    on<NotifyScreen>((event, emit) => emit(NotifyScreenState()));
  }

  HomeState get initialState => InitialHomeState();

  Future<void> _getDashboardData(LoadHomeScreen event, Emitter<HomeState> emit) async {
    try {
      emit(ShowProgressBar());
      String serverDateTime = "";
      Meta metaServerTime = await ServiceRepository().getServerDateTime();
      GMLogger.v("server time" + metaServerTime.statusMsg);
      if (metaServerTime.statusCode == 200) {
        serverDateTime = jsonDecode(metaServerTime.statusMsg)['response'];
        Constants.AUTH_LAST_ACCESS_DATE = DateFormat('MMM dd,yyyy | hh:mm a').format(DateTimeUtils().stringToDate(serverDateTime, DateTimeUtils.ServerFormat));
        ;
      }
      Meta meta = await ServiceRepository().getWeeklyData(event.userId, event.roleId, zhId: event.zhId);
      GMLogger.v("weekly sauda" + meta.statusMsg);
      GMLogger.v("weekly sauda" + meta.statusCode.toString());
      Meta meta2 = await ServiceRepository().getWeeklySalesData(event.userId, event.roleId, zhId: event.zhId);
      GMLogger.v("weekly sales" + meta2.statusMsg);
      GMLogger.v("weekly sales" + meta2.statusCode.toString());
      Meta meta3 = await ServiceRepository().getNotifications(event.userId);
      GMLogger.v("noti sales" + meta3.statusMsg);
      GMLogger.v("noti sales" + meta3.statusCode.toString());
      Meta meta4 = await ServiceRepository().getTickerList(event.userId);
      GMLogger.v("ticker" + meta4.statusMsg);
      GMLogger.v("ticker" + meta4.statusCode.toString());
      List<TickerList> tickerList = [];
      WeeklySalesResponse sresponse = WeeklySalesResponse();
      if (meta2.statusCode == 200) {
        sresponse = WeeklySalesResponse.fromJson(jsonDecode(meta2.statusMsg)['response']);
      }
      if (meta4.statusCode == 200) {
        jsonDecode(meta4.statusMsg)['response'].forEach((f) => tickerList.add(TickerList.fromJson(f)));
      }
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        WeeklyResponse response = WeeklyResponse.fromJson(jsonDecode(meta.statusMsg)['response']);
        GMLogger.v(" res:" + response.toString());
        emit(OnSuccess(response: response, salesResponse: sresponse, tickerList: tickerList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getOverallData(LoadOverallData event, Emitter<HomeState> emit) async {
    try {
      emit(ShowProgressBar());
      String fromDate = "2022-04-01";
      String toDate = "2022-06-30";
      Map<String, DateTime> resultDates = DateTimeUtils.getChartDates(event.selectedMethod);
      fromDate = DateTimeUtils().dateToStringFormat(resultDates["fromdate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      toDate = DateTimeUtils().dateToStringFormat(resultDates["todate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      Meta meta = await ServiceRepository().getOverallData(event.userId, fromDate, toDate, event.roleId, true, zhId: event.zhId);
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      Meta meta1 = await ServiceRepository().getOverallSalesData(event.userId, fromDate, toDate, event.roleId, true, zhId: event.zhId);
      GMLogger.v("sales overall" + meta1.statusMsg);
      GMLogger.v("sales overall" + meta1.statusCode.toString());
      OverallDashboard sresponse = OverallDashboard();
      if (meta1.statusCode == 200) {
        sresponse = OverallDashboard.fromJson(jsonDecode(meta1.statusMsg)['response']);
      }

      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        OverallDashboard response = OverallDashboard();
        response = OverallDashboard.fromJson(jsonDecode(meta.statusMsg)['response']);
        GMLogger.v(" res:" + response.toString());
        emit(OnOverallSuccess(response: response, salesResponse: sresponse));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getStatistics(LoadUserStatistics event, Emitter<HomeState> emit) async {
    try {
      emit(ShowProgressBar());
      String fromDate = "2022-04-01";
      String toDate = "2022-06-30";
      Map<String, DateTime> resultDates = DateTimeUtils.getChartDates(event.selectedMethod);
      fromDate = DateTimeUtils().dateToStringFormat(resultDates["fromdate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      toDate = DateTimeUtils().dateToStringFormat(resultDates["todate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      Meta meta = await ServiceRepository().getBDOStatistics(event.userId, fromDate, toDate, event.roleId, true, zhId: event.zhId);
      GMLogger.v("BDO" + meta.statusMsg);
      GMLogger.v("BDO" + meta.statusCode.toString());

      Meta metaDealerList = await ServiceRepository().getDealerByUserIdList(Constants.AUTH_USERID, 0, 0, 0);
      GMLogger.v("Dealer list" + metaDealerList.statusCode.toString());
      List<DistributorList> distList = [];
      DistributorList defaultDist = DistributorList();
      defaultDist.id = 0;
      defaultDist.employeeCode = "0";
      defaultDist.employeeName = "All Distributor";
      distList.add(defaultDist);
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      StatisticsResponse response = StatisticsResponse();
      if (meta.statusCode == 200) {
        response = StatisticsResponse.fromJson(jsonDecode(meta.statusMsg)['response']);
      }
      if (meta.statusCode == 200) {
        // emit(HideProgressBar());
        GMLogger.v(" res:" + response.toString());
        emit(OnStatisticsSuccess(response: response, distributorList: distList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getLastAliveTime(LoadLastAliveTime event, Emitter<HomeState> emit) async {
    try {
      // emit(ShowProgressBar());
      Meta meta = await ServiceRepository().getLastAliveTime();
      if (meta.statusCode == 200) {
        GMLogger.v(meta.toString());
        // emit(HideProgressBar());
        emit(const onLastAliveTimeSuccess());
      } else {
        // emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      // emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
