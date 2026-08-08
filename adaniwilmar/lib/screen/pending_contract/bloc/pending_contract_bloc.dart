import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/pending_contract_filter_response.dart';
import 'package:adaniwilmar/models/pending_contract_report_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/pending_contract/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class PendingContractBloc
    extends Bloc<PendingContractEvent, PendingContractState> {
  PendingContractBloc() : super(InitialPendingContractState()) {
    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadPendingContractScreen>(
        (event, emit) => _getDistributorList(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadActiveStates>((event, emit) => _getStates(event, emit));
    on<LoadPendingContractData>((event, emit) => _getStatusReport(event, emit));
    on<LoadPendingContractFilter>(
        (event, emit) => _getPendingContractFilter(event, emit));
  }
  PendingContractState get initialState => InitialPendingContractState();

  Future<void> _getDistributorList(LoadPendingContractScreen event,
      Emitter<PendingContractState> emit) async {
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

  Future<void> _getBdoList(
      LoadBDO event, Emitter<PendingContractState> emit) async {
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
      LoadSalesOrganization event, Emitter<PendingContractState> emit) async {
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
      LoadDistributionChannel event, Emitter<PendingContractState> emit) async {
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
      LoadVerticalList event, Emitter<PendingContractState> emit) async {
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

  Future<void> _getStatusReport(
      LoadPendingContractData event, Emitter<PendingContractState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaPendingContract = await ServiceRepository().getPendingContract(
          Constants.AUTH_USERID,
          id: event.id,
          skuIds: event.skuIds);
      GMLogger.v("report" + metaPendingContract.statusMsg);
      PendingContractReport reportData = PendingContractReport();
      if (metaPendingContract.statusCode == 200) {
        reportData = PendingContractReport.fromJson(
            jsonDecode(metaPendingContract.statusMsg)['response']);
      }
      if (metaPendingContract.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnPendingContractDataSuccess(pendingContractData: reportData));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaPendingContract.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getPendingContractFilter(LoadPendingContractFilter event,
      Emitter<PendingContractState> emit) async {
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
        emit(OnPendingContractFilterSuccess(
            pendingContractFilters: filterValue));
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
      LoadActiveStates event, Emitter<PendingContractState> emit) async {
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
}
