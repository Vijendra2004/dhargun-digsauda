import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/state_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/today_rate/bloc/todayrate_event.dart';
import 'package:adaniwilmar/screen/today_rate/bloc/todayrate_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';
import '../../../models/sauda_booking_status.dart';

class TodayRateBloc extends Bloc<TodayRateEvent, TodayRateState> {
  TodayRateBloc() : super(InitialTodayRateState()) {
    on<LoadStates>((event, emit) => _getStates(event, emit));
    on<LoadSalesOrganization>(
        (event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadIncoTerms>((event, emit) => _getIncoTermsData(event, emit));
    on<LoadPlant>((event, emit) => _getPlantData(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    on<LoadDealerDetail>(
            (event, emit) => _getDealerData(event, emit));
    on<GetTodayCreationStatus>(
            (event, emit) => _getTodayRateStatus(event, emit));



    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  TodayRateState get initialState => InitialTodayRateState();

  Future<void> _getTodayRateStatus(
      GetTodayCreationStatus event, Emitter<TodayRateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getSaudaBookingStatus(Constants.AUTH_USERID);
      GMLogger.v("Dealer123" + metaDealerList.statusMsg);
      SaudaBookingStatus saudaBookingStatus = SaudaBookingStatus();
      if (metaDealerList.statusCode == 200) {
        saudaBookingStatus = SaudaBookingStatus.fromJson(
            jsonDecode(metaDealerList.statusMsg)['response']);
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(GetTodayRateBooking(todayRateBookingStatus: saudaBookingStatus));
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

  Future<void> _getDistributorData(
      LoadSalesOrganization event, Emitter<TodayRateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getSalesOrganization(0);
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

  Future<void> _getDealerData(
      LoadDealerDetail event, Emitter<TodayRateState> emit) async {
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
            dealerSaudaDetail: saudaDetail));
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

  Future<void> _getStates(
      LoadStates event, Emitter<TodayRateState> emit) async {
    try {
      emit(ShowProgressBar());
      if(Constants.AUTH_ROLEID==Constants.DEALER){
        Meta states = await ServiceRepository().getDistributorStateList(Constants.AUTH_USERID);
        GMLogger.v("States" + states.statusMsg);
        GMLogger.v("States" + states.statusCode.toString());
        List<ActiveState> stateList = [];
        if (states.statusCode == 200) {
          stateList.add(ActiveState.fromJson(jsonDecode(states.statusMsg)['response']));
        }

        if (states.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadStates(states: stateList));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: states.statusMsg));
        }
      }else {
        Meta states = await ServiceRepository().getActiveStateList();
        GMLogger.v("States" + states.statusMsg);
        GMLogger.v("Sales" + states.statusCode.toString());
        List<ActiveState> stateList = [];
        if (states.statusCode == 200) {
          jsonDecode(states.statusMsg)['response']
              .forEach((f) => stateList.add(ActiveState.fromJson(f)));
        }

        if (states.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadStates(states: stateList));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: states.statusMsg));
        }
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributionChannelData(
      LoadDistributionChannel event, Emitter<TodayRateState> emit) async {
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
      LoadVerticalList event, Emitter<TodayRateState> emit) async {
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

  Future<void> _getOilTypeData(
      LoadOilType event, Emitter<TodayRateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeList(
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

  Future<void> _getIncoTermsData(
      LoadIncoTerms event, Emitter<TodayRateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getIncoTermsList();
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<IncoTerms> incoTerms = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => incoTerms.add(IncoTerms.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadIncoTerms(incoTerms: incoTerms));
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

  Future<void> _getPlantData(
      LoadPlant event, Emitter<TodayRateState> emit) async {
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

  Future<void> _getOverallData(
      LoadOverallData event, Emitter<TodayRateState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository().getDailyRateNew(
          Constants.AUTH_USERID,
          "0",
          event.oilTypeId.toString(),
          event.incoTermId.toString(),
          event.plantId.toString(),
          "0",
          event.salesOrgId.toString(),
          event.distrChannelId.toString(),
          event.verticalId.toString());
      GMLogger.v(meta.statusMsg);
      GMLogger.v(meta.statusCode.toString());
      if (meta.statusCode == 200) {
        emit(HideProgressBar());
        List<DailyRate> dailyRate = [];
        if (meta.statusCode == 200) {
          jsonDecode(meta.statusMsg)['response']
              .forEach((f) => dailyRate.add(DailyRate.fromJson(f)));
        }
        GMLogger.v(" res:" + dailyRate.toString());
        emit(OnOverallSuccess(response: dailyRate));
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
}
