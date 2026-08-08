// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/sauda_extension_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/saudu_extension_details/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaExtensionDetailBloc
    extends Bloc<SaudaExtensionDetailEvent, SaudaExtensionDetailState> {
  SaudaExtensionDetailBloc() : super(InitialSaudaExtensionDetailState()) {
    on<LoadSaudaExtensionDetailScreen>(
        (event, emit) => _getSaudaExtensionDetailData(event, emit));
    on<SaveSaudaExtension>((event, emit) => _saveSaudaExtension(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SaudaExtensionDetailState get initialState =>
      InitialSaudaExtensionDetailState();

  Future<void> _getSaudaExtensionDetailData(
      LoadSaudaExtensionDetailScreen event,
      Emitter<SaudaExtensionDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository()
          .getBookedSaudaWithextensionDetailsList(event.userId);
      GMLogger.v("ext" + metaSaudaList.statusMsg);
      GMLogger.v("ext" + metaSaudaList.statusCode.toString());
      List<SaudaExtension> info = [];
      if (metaSaudaList.statusCode == 200) {
        jsonDecode(metaSaudaList.statusMsg)['response']
            .forEach((f) => info.add(SaudaExtension.fromJson(f)));
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(saudaExtensions: info));
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

  Future<void> _saveSaudaExtension(
      SaveSaudaExtension event, Emitter<SaudaExtensionDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
          await ServiceRepository().saveSaudaExtension(event.request);
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
}
