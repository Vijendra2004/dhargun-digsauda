// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/customer_audio_file.dart';
import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sauda_details/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SaudaDetailBloc extends Bloc<SaudaDetailEvent, SaudaDetailState> {
  SaudaDetailBloc() : super(InitialSaudaDetailState()) {
    on<LoadSaudaDetailScreen>((event, emit) => _getSaudaDetailData(event, emit));
    on<LoadCustomerAudioList>((event, emit) => _getCustomerAudioList(event, emit));
    on<SaveAudioList>((event, emit) => _saveAudioList(event, emit));
  }

  SaudaDetailState get initialState => InitialSaudaDetailState();

  Future<void> _getSaudaDetailData(LoadSaudaDetailScreen event, Emitter<SaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository().getSauda(event.userId, event.saudaId);
      GMLogger.v("Dealer" + metaSaudaList.statusMsg);
      GMLogger.v("Dealer" + metaSaudaList.statusCode.toString());
      // BookedSaudha info = BookedSaudha(pendingList: [], approvedList: []);
      SaudaDetailResponse response = SaudaDetailResponse();
      if (metaSaudaList.statusCode == 200) {
        response = SaudaDetailResponse.fromJson(jsonDecode(metaSaudaList.statusMsg)['response']);
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(saudaDetailResponse: response));
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

  Future<void> _getCustomerAudioList(LoadCustomerAudioList event, Emitter<SaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaAudioList = await ServiceRepository().getCustomerAudio(event.dealerId, event.brokerId);
      GMLogger.v("audio" + metaAudioList.statusMsg);
      GMLogger.v("audio" + metaAudioList.statusCode.toString());
      // BookedSaudha info = BookedSaudha(pendingList: [], approvedList: []);
      List<CustomerAudioFile> audioResponse = [];
      if (metaAudioList.statusCode == 200) {
        jsonDecode(metaAudioList.statusMsg)['response'].forEach((f) => audioResponse.add(CustomerAudioFile.fromJson(f)));
      }

      if (metaAudioList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadCustomerAudio(audioResponse: audioResponse));
      } else {
        emit(HideProgressBar());
        emit(OnLoadCustomerAudio(audioResponse: []));
        emit(OnFailure(error: metaAudioList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveAudioList(SaveAudioList event, Emitter<SaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda = await ServiceRepository().saveAudioMapping(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveSuccess(response: jsonDecode(savedSauda.statusMsg)['response']));
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
