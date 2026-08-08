import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/cheque_pending_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/cheque_status_report/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class ChequeStatusBloc extends Bloc<ChequeStatusEvent, ChequeStatusState> {
  ChequeStatusBloc() : super(InitialChequeStatusState()) {
    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadChequeStatusScreen>(
        (event, emit) => _getDistributorList(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadChequeStatusData>((event, emit) => _getStatusReport(event, emit));
  }
  ChequeStatusState get initialState => InitialChequeStatusState();

  Future<void> _getDistributorList(
      LoadChequeStatusScreen event, Emitter<ChequeStatusState> emit) async {
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
      LoadBDO event, Emitter<ChequeStatusState> emit) async {
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
      LoadSalesOrganization event, Emitter<ChequeStatusState> emit) async {
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
      LoadDistributionChannel event, Emitter<ChequeStatusState> emit) async {
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
      LoadVerticalList event, Emitter<ChequeStatusState> emit) async {
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
      LoadChequeStatusData event, Emitter<ChequeStatusState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaChequeList = await ServiceRepository().getChequePending(
          Constants.AUTH_USERID, event.bdoIds, event.dealerIds);
      List<ChequePending> chequeList = [];
      if (metaChequeList.statusCode == 200) {
        jsonDecode(metaChequeList.statusMsg)['response']
            .forEach((f) => chequeList.add(ChequePending.fromJson(f)));
      }
      if (metaChequeList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnChequeStatusDataSuccess(chequePendingStatus: chequeList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaChequeList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
