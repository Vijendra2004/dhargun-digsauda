import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/competitor_list.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/oiltype_skulist.dart';
import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/models/today_activity_list.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/daily_sales_report/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class DailySalesReportBloc
    extends Bloc<DailySalesReportEvent, DailySalesReportState> {
  DailySalesReportBloc() : super(InitialDailySalesReportState()) {
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadDailySalesReportScreen>(
        (event, emit) => _getDailySalesReport(event, emit));
    on<LoadDealerVisitScreen>(
            (event, emit) => _getDealerVisitData(event, emit));
    on<LoadSKUDetails>((event, emit) => _getSKUData(event, emit));
    on<SaveDealerVisit>((event, emit) => _saveDealerVisit(event, emit));
    on<SaveWholesalerVisit>((event, emit) => _saveWholesalerVisit(event, emit));
    on<SavePerspectiveVisit>((event, emit) => _savePerspectiveVisit(event, emit));
    on<SubmitDailySalesReport>((event, emit) => _submitDailySalesReport(event, emit));
  }
  DailySalesReportState get initialState =>
      InitialDailySalesReportState();

  Future<void> _getDailySalesReport(LoadDailySalesReportScreen event,
      Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      String serverDateTime="";
      Meta metaServerTime =
          await ServiceRepository().getServerDateTime();
      List<TodayActivity> activityList = [];
      GMLogger.v("server time"+metaServerTime.statusMsg);
      if (metaServerTime.statusCode == 200) {
        serverDateTime=jsonDecode(metaServerTime.statusMsg)['response'];
      }
      Meta metaDailySales =
      await ServiceRepository().getTodayActivities(Constants.AUTH_USERID,serverDateTime);
      GMLogger.v("daily sales"+metaDailySales.statusMsg);
      if (metaDailySales.statusCode == 200) {
        jsonDecode(metaDailySales.statusMsg)['response']
            .forEach((f) => activityList.add(TodayActivity.fromJson(f)));
      }
      if (metaServerTime.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(activityList: activityList,serverDate:serverDateTime));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaServerTime.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDealerVisitData(LoadDealerVisitScreen event,
      Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList =
      await ServiceRepository().getSaudaNumberList(Constants.AUTH_USERID);
      GMLogger.v("sauda list"+metaSaudaList.statusMsg);
      List<SaudaList> saudaList = [];
      if (metaSaudaList.statusCode == 200) {
        jsonDecode(metaSaudaList.statusMsg)['response']
            .forEach((f) => saudaList.add(SaudaList.fromJson(f)));
      }
      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerVisit(saudaList: saudaList));
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

  Future<void> _getSKUData(
      LoadSKUDetails event, Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList =
          await ServiceRepository().getSkuByOilType(event.oilTypeId);
      List<OilTypeSkuList> skuList = [];
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response']
            .forEach((f) => skuList.add(OilTypeSkuList.fromJson(f)));
      }

      if (metaSkuList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSKUDetails(
            skuList: skuList, currentIndex: event.currentIndex));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSkuList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeList(
          Constants.AUTH_USERID,
          salesOrgId: 0,
          distriChannelId: 0,
          divisionId: 0);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<OilType> oilTypes = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => oilTypes.add(OilType.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilType(oilTypes: oilTypes));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveDealerVisit(
      SaveDealerVisit event, Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().saveDealerVisit(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSavePriceDiscovery(
            response: jsonDecode(savedSauda.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveWholesalerVisit(
      SaveWholesalerVisit event, Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().saveWholesalerVisit(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSavePriceDiscovery(
            response: jsonDecode(savedSauda.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _savePerspectiveVisit(
      SavePerspectiveVisit event, Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().addProspectiveDealer(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSavePriceDiscovery(
            response: jsonDecode(savedSauda.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _submitDailySalesReport(
      SubmitDailySalesReport event, Emitter<DailySalesReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().submitDailySalesReport(event.userId,event.mtpId,event.remarks);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        if(jsonDecode(savedSauda.statusMsg)['response']["isSuccess"]){
          emit(OnSavePriceDiscovery(response: "Successfully submitted" ));
        }else{
          emit(OnFailure(error: jsonDecode(savedSauda.statusMsg)['response']["errorDto"]["message"]));
        }
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

}
