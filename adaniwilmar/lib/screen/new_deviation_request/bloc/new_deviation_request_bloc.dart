import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/deviation_add_request.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/new_deviation_request/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class NewDeviationRequestBloc
    extends Bloc<NewDeviationRequestEvent, NewDeviationRequestState> {
  NewDeviationRequestBloc() : super(InitialNewDeviationRequestState()) {
    on<LoadDeviationReason>((event, emit) => _getDeviationReason(event, emit));
    on<LoadApprovedTourPlan>(
        (event, emit) => _getApprovedTourPlanData(event, emit));
    on<LoadTourPlanDetailList>(
        (event, emit) => _getTourPlanDetailData(event, emit));
    on<SaveDeviation>((event, emit) => _saveDeviation(event, emit));
  }
  NewDeviationRequestState get initialState =>
      InitialNewDeviationRequestState();

  Future<void> _getDeviationReason(
      LoadDeviationReason event, Emitter<NewDeviationRequestState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta approvedTourPlan = await ServiceRepository().getSTPReasonsList();
      GMLogger.v("Sales" + approvedTourPlan.statusMsg);
      GMLogger.v("Sales" + approvedTourPlan.statusCode.toString());
      List<DeviationReason> deviationReasonList = [];
      if (approvedTourPlan.statusCode == 200) {
        jsonDecode(approvedTourPlan.statusMsg)['response'].forEach(
            (f) => deviationReasonList.add(DeviationReason.fromJson(f)));
      }

      if (approvedTourPlan.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDeviationReason(deviationReasonList: deviationReasonList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: approvedTourPlan.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getApprovedTourPlanData(LoadApprovedTourPlan event,
      Emitter<NewDeviationRequestState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta approvedTourPlan =
          await ServiceRepository().getApprovedMTPByUser(event.id);
      GMLogger.v("Dealer" + approvedTourPlan.statusMsg);
      GMLogger.v("Dealer" + approvedTourPlan.statusCode.toString());
      List<ApprovedMtp> approvedTourPlanList = [];
      if (approvedTourPlan.statusCode == 200) {
        jsonDecode(approvedTourPlan.statusMsg)['response']
            .forEach((f) => approvedTourPlanList.add(ApprovedMtp.fromJson(f)));
      }

      if (approvedTourPlan.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadApprovedTourPlan(approvedTourPlan: approvedTourPlanList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: approvedTourPlan.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getTourPlanDetailData(LoadTourPlanDetailList event,
      Emitter<NewDeviationRequestState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta approvedTourPlan =
          await ServiceRepository().getApprovedMTPDetailByUser(event.mtpId);
      GMLogger.v("Dealer" + approvedTourPlan.statusMsg);
      GMLogger.v("Dealer" + approvedTourPlan.statusCode.toString());
      List<TourPlanDetail> tourPlanDetailList = [];
      if (approvedTourPlan.statusCode == 200) {
        jsonDecode(approvedTourPlan.statusMsg)['response']
            .forEach((f) => tourPlanDetailList.add(TourPlanDetail.fromJson(f)));
      }

      if (approvedTourPlan.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadTourPlanDetailList(tourPlanDetail: tourPlanDetailList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: approvedTourPlan.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveDeviation(
      SaveDeviation event, Emitter<NewDeviationRequestState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda = await ServiceRepository()
          .MTPDeviationAdd(Constants.AUTH_USERID, event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveDeviation(
            response: DeviationAddResponse.fromJson(
                jsonDecode(savedSauda.statusMsg)['response'])));
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
