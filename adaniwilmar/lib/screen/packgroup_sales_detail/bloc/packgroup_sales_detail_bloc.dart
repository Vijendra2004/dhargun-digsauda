// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_invoice_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/packgroup_sales_detail/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class PackGroupDetailDetailBloc
    extends Bloc<PackGroupDetailDetailEvent, PackGroupDetailDetailState> {
  PackGroupDetailDetailBloc() : super(InitialPackGroupDetailDetailState()) {
    on<LoadPackGroupDetailDetailScreen>(
        (event, emit) => _getPackGroupDetailDetailData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  PackGroupDetailDetailState get initialState =>
      InitialPackGroupDetailDetailState();

  Future<void> _getPackGroupDetailDetailData(
      LoadPackGroupDetailDetailScreen event,
      Emitter<PackGroupDetailDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaRequestList = await ServiceRepository().getPackGroupDealerSales(
          event.userId,
          event.fromDate,
          event.toDate,
          event.dealerId,
          event.packGroupId,false);
      GMLogger.v("Req" + metaRequestList.statusMsg);
      GMLogger.v("Req" + metaRequestList.statusCode.toString());
      DealerInvoices invoices = DealerInvoices();
      if (metaRequestList.statusCode == 200) {
        invoices = DealerInvoices.fromJson(
            jsonDecode(metaRequestList.statusMsg)['response']);
      }

      if (metaRequestList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(dealerInvoiceResponse: invoices));
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
