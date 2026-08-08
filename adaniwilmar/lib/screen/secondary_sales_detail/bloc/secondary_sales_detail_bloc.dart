// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/secondary_sales_detail/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SecondarySalesDetailBloc
    extends Bloc<SecondarySalesDetailEvent, SecondarySalesDetailState> {
  SecondarySalesDetailBloc() : super(InitialSecondarySalesDetailState()) {
    on<LoadSecondarySalesDetailScreen>(
        (event, emit) => _getSecondarySalesDetailData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SecondarySalesDetailState get initialState =>
      InitialSecondarySalesDetailState();

  Future<void> _getSecondarySalesDetailData(
      LoadSecondarySalesDetailScreen event,
      Emitter<SecondarySalesDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSaudaList = await ServiceRepository()
          .getSecondarySalesFortheDayDetail(
              event.userId, event.wholeSellerId, event.visitDate);
      GMLogger.v("ss" + metaSaudaList.statusMsg);
      GMLogger.v("ss" + metaSaudaList.statusCode.toString());
      // BookedSaudha info = BookedSaudha(pendingList: [], approvedList: []);
      List<SecondarySalesFortheDayDetailViewDto> response = [];
      if (metaSaudaList.statusCode == 200) {
        jsonDecode(metaSaudaList.statusMsg)['response'].forEach((f) =>
            response.add(SecondarySalesFortheDayDetailViewDto.fromJson(f)));
      }

      if (metaSaudaList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(secondarySalesDetail: response));
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
}
