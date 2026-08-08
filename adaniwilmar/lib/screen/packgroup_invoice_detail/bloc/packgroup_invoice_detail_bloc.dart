// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/invoice_detail_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/packgroup_invoice_detail/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class PackGroupInvoiceDetailBloc
    extends Bloc<PackGroupInvoiceDetailEvent, PackGroupInvoiceDetailState> {
  PackGroupInvoiceDetailBloc() : super(InitialPackGroupInvoiceDetailState()) {
    on<LoadPackGroupInvoiceDetailScreen>(
        (event, emit) => _getPackGroupInvoiceDetailData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event, emit));
    // on<LoadUserStatistics>((event, emit) => _getStatistics(event,emit));
  }
  PackGroupInvoiceDetailState get initialState =>
      InitialPackGroupInvoiceDetailState();

  Future<void> _getPackGroupInvoiceDetailData(
      LoadPackGroupInvoiceDetailScreen event,
      Emitter<PackGroupInvoiceDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaRequestList = await ServiceRepository()
          .getPackGroupInvoiceDetail(
              event.userId, event.id, event.isBulkPack, event.isPendingSauda);
      GMLogger.v("Req" + metaRequestList.statusMsg);
      GMLogger.v("Req" + metaRequestList.statusCode.toString());
      InvoiceDetail invoice = InvoiceDetail();
      if (metaRequestList.statusCode == 200) {
        invoice = InvoiceDetail.fromJson(
            jsonDecode(metaRequestList.statusMsg)['response']);
      }

      if (metaRequestList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(invoiceResponse: invoice));
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
