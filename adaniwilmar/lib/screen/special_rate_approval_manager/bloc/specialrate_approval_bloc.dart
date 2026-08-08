// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/special_rate_view_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/special_rate_approval_manager/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SpecialRateApprovalManagerBloc extends Bloc<
    SpecialRateApprovalManagerEvent, SpecialRateApprovalManagerState> {
  SpecialRateApprovalManagerBloc()
      : super(InitialSpecialRateApprovalManagerState()) {
    on<LoadSalesOrganization>(
            (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>(
            (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadSpecialRateApprovalManagerScreen>(
        (event, emit) => _getSpecialRateApprovalManagerData(event, emit));
    on<LoadBdoList>((event, emit) => _getBDOList(event, emit));
    on<SaveApproval>(
        (event, emit) => _saveSpecialRateApprovalManager(event, emit));
  }
  SpecialRateApprovalManagerState get initialState =>
      InitialSpecialRateApprovalManagerState();

  Future<void> _getSpecialRateApprovalManagerData(
      LoadSpecialRateApprovalManagerScreen event,
      Emitter<SpecialRateApprovalManagerState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSpecialRateList = await ServiceRepository()
          .getSpecialRateApprovalListManager(
              event.userId, event.fromDate, event.toDate, event.bdoId,event.statusId);
      GMLogger.v("Dealer" + metaSpecialRateList.statusMsg);
      GMLogger.v("Dealer" + metaSpecialRateList.statusCode.toString());
      List<SpecialRateList> info = [];
      if (metaSpecialRateList.statusCode == 200) {
        jsonDecode(metaSpecialRateList.statusMsg)['response']
            .forEach((f) => info.add(SpecialRateList.fromJson(f)));
      }
      if (metaSpecialRateList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(specialRateList: info));
      } else {
        emit(HideProgressBar());
        emit(const OnLoadSuccess(specialRateList: []));
        emit(OnFailure(error: metaSpecialRateList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getBDOList(
      LoadBdoList event, Emitter<SpecialRateApprovalManagerState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getBDOListForTp(Constants.AUTH_USERID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<BdoList> bdoList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadBdoList(bdoList: bdoList));
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

  Future<void> _saveSpecialRateApprovalManager(
      SaveApproval event, Emitter<SpecialRateApprovalManagerState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().saveSpecialRateApproval(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(const OnSaveSuccess(saved: true));
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
  Future<void> _getSalesOrganization(LoadSalesOrganization event,
      Emitter<SpecialRateApprovalManagerState> emit) async {
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

  Future<void> _getDistributionChannelData(LoadDistributionChannel event,
      Emitter<SpecialRateApprovalManagerState> emit) async {
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
      LoadVerticalList event, Emitter<SpecialRateApprovalManagerState> emit) async {
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
}
