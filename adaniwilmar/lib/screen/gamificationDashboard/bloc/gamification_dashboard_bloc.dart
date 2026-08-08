import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/gamification_model.dart';
import '../../../repo/service_repository.dart';
import 'gamification_dashboard_event.dart';
import 'gamification_dashboard_state.dart';

class GamificationDashboardBloc extends Bloc<GamificationDashboardEvent, GamificationDashboardState> {
  GamificationDashboardBloc() : super(GamificationDashboardInitial()) {
    on<LoadGamificationDashboardData>((event, emit) => _getOverallData(event, emit));
  }

  GamificationDashboardInitial get initialState => GamificationDashboardInitial();

  Future<void> _getOverallData(LoadGamificationDashboardData event, Emitter<GamificationDashboardState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getGamificationDashboardDetails(event.dealerCode);

      if (metaDealerList.statusCode == 200) {

        GamificationFieldsData response = GamificationFieldsData();
        response = GamificationFieldsData.fromJson(jsonDecode(metaDealerList.statusMsg)['response']);
        emit(OnLoadGamificationDashboardDataSuccess(response: response));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
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
}
