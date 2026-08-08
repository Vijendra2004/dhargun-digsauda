import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/credit_limit_total.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sales/bloc/bloc.dart';
import 'package:adaniwilmar/utils/datetime_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(InitialSalesState()) {
    on<LoadSalesScreen>((event, emit) => _getSalesData(event, emit));
    on<LoadSalesChart>((event, emit) => _getSalesChartData(event, emit));
    on<LoadDealerSales>((event, emit) => _getDealerSalesData(event, emit));
  }
  SalesState get initialState => InitialSalesState();

  Future<void> _getSalesData(
      LoadSalesScreen event, Emitter<SalesState> emit) async {
    try {
      emit(ShowProgressBar());
      String fromDate = event.fromDate;
      String toDate = event.toDate;
      Map<String,DateTime> resultDates=DateTimeUtils.getChartDates(event.selectedMethod);
      fromDate=DateTimeUtils().dateToStringFormat(resultDates["fromdate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      toDate=DateTimeUtils().dateToStringFormat(resultDates["todate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      Meta creditLimitMeta = await ServiceRepository().getCreditLimitTotal(
          Constants.AUTH_USERID,
          fromDate,
          toDate,
          event.isBulkPack);
      GMLogger.v("credit limt "+creditLimitMeta.statusMsg);
      CreditLimitTotal creditLimitTotal = CreditLimitTotal();
      if (creditLimitMeta.statusCode == 200) {
        creditLimitTotal = CreditLimitTotal.fromJson(
            jsonDecode(creditLimitMeta.statusMsg)['response']);
      }
      if (creditLimitMeta.statusCode == 200) {
        //This progressbar will hide on sales chart function
        // emit(HideProgressBar());
        emit(OnLoadSuccess(creditLimitTotal: creditLimitTotal));
      } else {
        //This progressbar will hide on sales chart function
        // emit(HideProgressBar());
        emit(OnFailure(error: creditLimitMeta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      //This progressbar will hide on sales chart function
      // emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }


   await _getSalesChartData(LoadSalesChart(
        userId: event.userId,
        fromDate: event.fromDate,
        toDate: event.toDate,
        isBulkPack: event.isBulkPack,
        selectedMethod: event.selectedMethod),emit);
  }

  Future<void> _getSalesChartData(
      LoadSalesChart event, Emitter<SalesState> emit) async {
    try {
      // emit(ShowProgressBar());
      String fromDate = event.fromDate;
      String toDate = event.toDate;
      Map<String,DateTime> resultDates=DateTimeUtils.getChartDates(event.selectedMethod);
      fromDate=DateTimeUtils().dateToStringFormat(resultDates["fromdate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      toDate=DateTimeUtils().dateToStringFormat(resultDates["todate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      Meta chartMeta = await ServiceRepository().getOverallChartSalesData(
          Constants.AUTH_USERID,
          fromDate,
          toDate,
          event.isBulkPack);
      GMLogger.v("sales chart"+chartMeta.statusMsg);
      SalesChartResponse salesChartData = SalesChartResponse(salesList: [],overallSales: 0,totalTarget: 0);
      if (chartMeta.statusCode == 200) {
        salesChartData=SalesChartResponse.fromJson(jsonDecode(chartMeta.statusMsg)['response']);
      }
      if (chartMeta.statusCode == 200) {
        emit(OnLoadChartSuccess(salesChartData: salesChartData));
        emit(HideProgressBar());
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: chartMeta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDealerSalesData(
      LoadDealerSales event, Emitter<SalesState> emit) async {
    try {
      emit(ShowProgressBar());
      String fromDate = event.fromDate;
      String toDate = event.toDate;
      Map<String,DateTime> resultDates=DateTimeUtils.getChartDates(event.selectedMethod);
      fromDate=DateTimeUtils().dateToStringFormat(resultDates["fromdate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      toDate=DateTimeUtils().dateToStringFormat(resultDates["todate"]!, DateTimeUtils.YYYY_MM_DD_Format);
      Meta chartMeta = await ServiceRepository().getDealerSalesData(
          Constants.AUTH_USERID,
          fromDate,
          toDate,
          event.isBulkPack);
      GMLogger.v("dealer"+chartMeta.statusMsg);
      DealerSalesChartResponse salesChartData = DealerSalesChartResponse(salesList: [],totalTarget: 0,overallSales: 0);
      if (chartMeta.statusCode == 200) {
        salesChartData=DealerSalesChartResponse.fromJson(jsonDecode(chartMeta.statusMsg)['response']);
            // .forEach((f) => salesChartData.add(DealerSalesChart.fromJson(f)));
      }
      if (chartMeta.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSalesSuccess(salesChartData: salesChartData));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: chartMeta.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
