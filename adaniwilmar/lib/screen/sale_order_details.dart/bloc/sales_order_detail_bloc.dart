// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_lifting_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sale_order_details.dart/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SalesOrderDetailBloc
    extends Bloc<SalesOrderDetailEvent, SalesOrderDetailState> {
  SalesOrderDetailBloc() : super(InitialSalesOrderDetailState()) {
    on<LoadSalesOrderDetailScreen>(
        (event, emit) => _getSalesOrderDetailData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  SalesOrderDetailState get initialState => InitialSalesOrderDetailState();

  Future<void> _getSalesOrderDetailData(LoadSalesOrderDetailScreen event,
      Emitter<SalesOrderDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaRequestList = await ServiceRepository()
          .getDealerLiftingRequestList(event.userId, event.dealerId,
              event.statusId, event.fromDate, event.toDate, event.isFilter);
      GMLogger.v("Req" + metaRequestList.statusMsg);
      GMLogger.v("Req" + metaRequestList.statusCode.toString());
      List<DealerLiftingResponse> response = [];
      if (metaRequestList.statusCode == 200) {
        jsonDecode(metaRequestList.statusMsg)['response']
            .forEach((f) => response.add(DealerLiftingResponse.fromJson(f)));
      }

      if (metaRequestList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(dealerLiftingResponse: response));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaRequestList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
