import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/limit_enhancement_history.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_limit_enhancement/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaLimitEnhancementBloc
    extends Bloc<SaudaLimitEnhancementEvent, SaudaLimitEnhancementState> {
  SaudaLimitEnhancementBloc() : super(InitialSaudaLimitEnhancementState()) {
    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDealerSaudaDetail>(
        (event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    on<LoadSaudaLimitEnhancementScreen>(
        (event, emit) => _getDistributorList(event, emit));
    on<SaveLimitEnhancement>(
        (event, emit) => _saveLimitEnhancement(event, emit));
    on<LoadSaudaLimitEnhancementHistoryScreen>(
        (event, emit) => _getLimitEnhancementHistory(event, emit));
  }
  SaudaLimitEnhancementState get initialState =>
      InitialSaudaLimitEnhancementState();

  Future<void> _getDistributorList(LoadSaudaLimitEnhancementScreen event,
      Emitter<SaudaLimitEnhancementState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerByUserIdList(
          Constants.AUTH_USERID,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisonId,
          bdoIds: event.bdoId > 0 ? [event.bdoId] : []);
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

  Future<void> _getSalesOrganization(LoadSalesOrganization event,
      Emitter<SaudaLimitEnhancementState> emit) async {
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

  Future<void> _getDistributorData(LoadDealerSaudaDetail event,
      Emitter<SaudaLimitEnhancementState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta dealerSaudaDetails = await ServiceRepository().getDealerSaudaDetails(
          event.id,
          event.salesOrganizationId,
          event.distributionChannelId,
          event.divisionId);
      DealerSaudaDetail saudaDetail = DealerSaudaDetail();
      if (dealerSaudaDetails.statusCode == 200) {
        GMLogger.v(dealerSaudaDetails.statusMsg);
        saudaDetail = DealerSaudaDetail.fromJson(
            jsonDecode(dealerSaudaDetails.statusMsg)['response']);
      }

      if (dealerSaudaDetails.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSaudaDetail(
            dealerSaudaDetail: saudaDetail, skuDetail: const []));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: dealerSaudaDetails.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributionChannelData(LoadDistributionChannel event,
      Emitter<SaudaLimitEnhancementState> emit) async {
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
      LoadVerticalList event, Emitter<SaudaLimitEnhancementState> emit) async {
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

  Future<void> _getBdoList(
      LoadBDO event, Emitter<SaudaLimitEnhancementState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      List<BdoList> bdoList = [];
      if (event.showAll) {
        BdoList bdo = BdoList();
        bdo.id = 0;
        bdo.name = "All State Traders";
        bdoList.add(bdo);
      }
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

  Future<void> _saveLimitEnhancement(SaveLimitEnhancement event,
      Emitter<SaudaLimitEnhancementState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().saveLimitEnhancement(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveLimitEnhancement(
            id: jsonDecode(savedSauda.statusMsg)['response']));
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

  Future<void> _getLimitEnhancementHistory(
      LoadSaudaLimitEnhancementHistoryScreen event,
      Emitter<SaudaLimitEnhancementState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getLimitEnhancementHistory(
        event.userId,
        event.id,
      );
      if (Constants.AUTH_ROLEID == Constants.DEALER) {
        List<Saudahistory> limitRequests = [];
        if (metaDealerList.statusCode == 200) {
          jsonDecode(metaDealerList.statusMsg)['response']
              .forEach((f) => limitRequests.add(Saudahistory.fromJson(f)));
        }
        if (metaDealerList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadDealerHistorySuccess(limitRequests: limitRequests));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaDealerList.statusMsg));
        }
      } else {
        List<LimitEnhancementHistory> limitRequests = [];
        if (metaDealerList.statusCode == 200) {
          jsonDecode(metaDealerList.statusMsg)['response'].forEach(
              (f) => limitRequests.add(LimitEnhancementHistory.fromJson(f)));
        }
        if (metaDealerList.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadHistorySuccess(limitRequests: limitRequests));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaDealerList.statusMsg));
        }
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
