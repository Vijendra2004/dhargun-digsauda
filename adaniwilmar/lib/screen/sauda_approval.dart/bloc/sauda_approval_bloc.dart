// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/sauda_approval_list.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_approval.dart/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaApprovalBloc extends Bloc<SaudaApprovalEvent, SaudaApprovalState> {
  SaudaApprovalBloc() : super(InitialSaudaApprovalState()) {
    on<LoadSaudaApprovalScreen>(
        (event, emit) => _getSaudaApprovalData(event, emit));
    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<SaveApproval>((event, emit) => _saveSaudaApproval(event, emit));
  }
  SaudaApprovalState get initialState => InitialSaudaApprovalState();

  Future<void> _getSaudaApprovalData(
      LoadSaudaApprovalScreen event, Emitter<SaudaApprovalState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository().getAdminAppList(
          event.userId,
          event.fromDate,
          event.toDate,
          event.salesOrganizationId,
          event.statusId,
          event.pageNo,
          event.distributionChannelId,
          event.divisionId);
      GMLogger.v("Dealer" + metaSaudaList.statusMsg);
      GMLogger.v("Dealer" + metaSaudaList.statusCode.toString());
      SaudaApprovalList info = SaudaApprovalList(listCount: 0, saudaList: []);
      if (metaSaudaList.statusCode == 200) {
        info = SaudaApprovalList.fromJson(
            jsonDecode(metaSaudaList.statusMsg)['response']);
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(bookedSaudha: info));
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

  Future<void> _getSalesOrganization(
      LoadSalesOrganization event, Emitter<SaudaApprovalState> emit) async {
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

  Future<void> _saveSaudaApproval(
      SaveApproval event, Emitter<SaudaApprovalState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().saveSaudaApproval(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(const OnSaveSuccess(saved: true));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg, saveError: true));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}

@override
Future<void> _getDistributionChannelData(
    LoadDistributionChannel event, Emitter<SaudaApprovalState> emit) async {
  try {
    emit(ShowProgressBar());
    Meta salesOrg = await ServiceRepository().getDistributionChannel(event.id);
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

@override
Future<void> _getVerticalData(
    LoadVerticalList event, Emitter<SaudaApprovalState> emit) async {
  try {
    emit(ShowProgressBar());
    Meta salesOrg = await ServiceRepository().getVertical(event.distributionId);
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
