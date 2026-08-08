import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/latest_update_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/updates/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';
import '../../../models/customer_ledger_response.dart';
import '../../../models/dealer_response.dart';
import '../../../utils/constant.dart';

class UpdatesBloc extends Bloc<UpdatesEvent, UpdatesState> {
  UpdatesBloc() : super(InitialUpdatesState()) {
    on<LoadUpdatesScreen>((event, emit) => _getLatestUpdate(event, emit));
  }

  UpdatesState get initialState => InitialUpdatesState();

  Future<void> _getLatestUpdate(
      LoadUpdatesScreen event, Emitter<UpdatesState> emit) async {
    try {
      emit(ShowProgressBar());

      Meta metaUpdates = await ServiceRepository()
          .getLatestUpdatesList(Constants.AUTH_USERID);
      GMLogger.v("updates" + metaUpdates.statusMsg);
      GMLogger.v("updates" + metaUpdates.statusCode.toString());
      List<LatestUpdateResponse> updates = [];
      if (metaUpdates.statusCode == 200) {
        jsonDecode(metaUpdates.statusMsg)['response']
            .forEach((f) => updates.add(LatestUpdateResponse.fromJson(f)));
        emit(HideProgressBar());
        emit(OnLoadSuccess(updates: updates));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaUpdates.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
