import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/pending_contract_filter_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sales_report_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/reports/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(InitialReportState()) {
    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadReportScreen>((event, emit) => _getDistributorList(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadActiveStates>((event, emit) => _getStates(event, emit));
    on<LoadReportData>((event, emit) => _getReportData(event, emit));
    on<LoadReportFilter>((event, emit) => _getReportFilter(event, emit));
    on<LoadPlant>((event, emit) => _getPlantData(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
  }

  ReportState get initialState => InitialReportState();

  Future<void> _getDistributorList(
      LoadReportScreen event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerByUserIdList(
          Constants.AUTH_USERID,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisonId,
          bdoIds: event.bdoIds);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(distributorList: distList));
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

  Future<void> _getBdoList(LoadBDO event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      List<BdoList> bdoList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadBDO(bdoList: bdoList));
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

  Future<void> _getSalesOrganization(
      LoadSalesOrganization event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository()
          .getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSalesOrganization(salesOrganization: salesOrgList));
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

  Future<void> _getDistributionChannelData(
      LoadDistributionChannel event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getDistributionChannel(event.id);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<DistributionChannel> distrChannels = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => distrChannels.add(DistributionChannel.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDistributionChannel(distributionChannel: distrChannels));
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

  Future<void> _getVerticalData(
      LoadVerticalList event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getVertical(event.distributionId);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<Vertical> verticals = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => verticals.add(Vertical.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadVerticalList(verticalList: verticals));
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

  Future<void> _getReportData(
      LoadReportData event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaReport;
      if (event.isSales) {
        metaReport = await ServiceRepository().getSalesReport(
            Constants.AUTH_USERID,
            event.fromDate,
            event.toDate,
            event.nationalHeadIds,
            event.dealerIds,
            event.bdoIds,
            event.zhIds,
            event.oilTypeIds,
            event.packGroupIds,
            event.stateIds,
            event.plantId,
        event.oilPackGroupTypeId
        );
      } else {
        metaReport = await ServiceRepository().getSaudaReport(
            Constants.AUTH_USERID,
            event.fromDate,
            event.toDate,
            event.nationalHeadIds,
            event.dealerIds,
            event.bdoIds,
            event.zhIds,
            event.oilTypeIds,
            event.packGroupIds,
            event.stateIds,
            event.plantId,
            event.oilPackGroupTypeId);
      }
      GMLogger.v("report" + metaReport.statusMsg);
      List<SalesReport> reportData = [];
      SaudaNHReport nhReportData =
          SaudaNHReport(saudaNHReportStateList: <SaudaNHReportStateList>[]);

      if(metaReport.statusCode == 504)
      {
        emit(HideProgressBar());
        emit(OnFailureInReport(error: "Connection Timeout!"));
      }
      if (metaReport.statusCode == 200) {
        if (!event.isSales) {
          nhReportData = SaudaNHReport.fromJson(
              jsonDecode(metaReport.statusMsg)['response']);
        } else {
          jsonDecode(metaReport.statusMsg)['response']
              .forEach((f) => reportData.add(SalesReport.fromJson(f)));
        }
      }
      if (metaReport.statusCode == 200) {
        emit(HideProgressBar());
        if (!event.isSales) {
          emit(OnNHReportDataSuccess(
              reportData: nhReportData, isSales: event.isSales));
        } else {
          emit(OnReportDataSuccess(
              reportData: reportData, isSales: event.isSales));
        }
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaReport.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getReportFilter(
      LoadReportFilter event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaFilter = await ServiceRepository()
          .getPendingContractFilters(Constants.AUTH_USERID);
      GMLogger.v("filter" + metaFilter.statusMsg);
      PendingContractFilterValue filterValue = PendingContractFilterValue();
      if (metaFilter.statusCode == 200) {
        filterValue = PendingContractFilterValue.fromJson(
            jsonDecode(metaFilter.statusMsg)['response']);
      }
      if (metaFilter.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnReportFilterSuccess(pendingContractFilters: filterValue));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaFilter.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getStates(
      LoadActiveStates event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta states = await ServiceRepository().getActiveStateList();
      List<ActiveState> stateList = [];
      if (states.statusCode == 200) {
        jsonDecode(states.statusMsg)['response']
            .forEach((f) => stateList.add(ActiveState.fromJson(f)));
      }
      GMLogger.v("States" + states.statusMsg);
      if (states.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadStates(states: stateList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: states.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getPlantData(LoadPlant event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getPlantListByUser(Constants.AUTH_USERID);
      GMLogger.v("Plant " + salesOrg.statusMsg);
      GMLogger.v("Plant " + salesOrg.statusCode.toString());
      List<PlanDepotList> plants = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => plants.add(PlanDepotList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPlant(plantList: plants));
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

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<ReportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeListByLoginId(
          Constants.AUTH_USERID,
          salesOrgId: event.salesOrganizationId,
          distriChannelId: event.distributionChannelId,
          divisionId: event.divisonId);
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
}
