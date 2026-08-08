// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/support_list_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/support/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc() : super(InitialSupportState()) {
    on<LoadSupportScreen>((event, emit) => _getSupportData(event, emit));
    on<SaveSupport>((event, emit) => _saveSupport(event, emit));
    on<LoadNewSupportScreen>((event, emit) => _getSupportMasterData(event,emit));
  }
  @override
  SupportState get initialState => InitialSupportState();

  @override
  Future<void> _getSupportData(LoadSupportScreen event, Emitter<SupportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaChart = await ServiceRepository()
          .getSupportList(event.userId,fromDate:event.fromDate,toDate:event.toDate);
      GMLogger.v("Support" + metaChart.statusMsg);
      GMLogger.v("Support" + metaChart.statusCode.toString());
      List<SupportList> info = [];
      if (metaChart.statusCode == 200) {
        jsonDecode(metaChart.statusMsg)['response']
            .forEach((f) => info.add(SupportList.fromJson(f)));
      }

      if (metaChart.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(supportData: info));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaChart.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
  @override
  Future<void> _getSupportMasterData(LoadNewSupportScreen event, Emitter<SupportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaChart = await ServiceRepository()
          .getSupportMaster(event.userId);
      GMLogger.v("Support master" + metaChart.statusMsg);
      GMLogger.v("Support master" + metaChart.statusCode.toString());
      SupportMaster info =SupportMaster();
      if (metaChart.statusCode == 200) {
        info=SupportMaster.fromJson(jsonDecode(metaChart.statusMsg)['response']);
      }

      if (metaChart.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnNewSupportSuccess(response: info));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaChart.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
  Future<void> _saveSupport(SaveSupport event, Emitter<SupportState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSalesOrder = await ServiceRepository().saveSupport(event.request);
      GMLogger.v(savedSalesOrder.statusCode.toString());
      GMLogger.v(savedSalesOrder.statusMsg);
      if (savedSalesOrder.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveSuccess(response: jsonDecode(savedSalesOrder.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSalesOrder.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
